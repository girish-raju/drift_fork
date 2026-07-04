# Fork: Per-Table Incremental Analysis Cache for drift_dev

This fork of [simolus3/drift](https://github.com/simolus3/drift) adds an **opt-in,
per-table incremental analysis cache** to `drift_dev`'s modular build. It exists
because analysis time in large schemas grows with *(number of build steps) ×
(number of reachable tables)*, which for a 400+ table project made every
regeneration take ~10 minutes regardless of how small the change was.

- Base: upstream release tag `drift_dev-2.34.0` (drift 2.34.0).
  (Newest tag that resolves against Flutter's pinned `meta 1.17.0`;
  `drift_dev >= 2.34.1` requires analyzer 13 / `meta >= 1.18.3`.)
- Feature flag: `incremental_generation: true` in the builder options.
  **Off by default; with the flag off the fork's output is byte-identical to
  stock 2.34.0** (verified against a 420-table production schema).

---

## 1. The upstream problem: same-phase cache blindness

drift_dev's modular pipeline runs (per input file) as build phases:

1. `discover` — parses a file, records its drift elements and import/export edges
   (`*.drift_elements.json`).
2. `analyzer` — resolves every element (tables, views, DAOs, databases) through
   the Dart analyzer and serializes the results (`*.drift_module.json`).
3. `modular` — reads module JSONs and emits the `.drift.dart` code.

Serialized analysis results are the designed cross-step cache: `DriftResolver.
_restoreOrResolve` deserializes an element instead of resolving it whenever
`driver.readStoredAnalysisResult(uri)` finds a module JSON. **But module JSONs are
outputs of the analyzer phase itself, and the build system forbids builders from
reading outputs of their own phase.** Consequently `readElementCacheFor` returns
`null` for every library still being analyzed in the current phase, and:

- `analyzer(tables_file.dart)` re-resolves **all** tables in that file;
- `analyzer(database.dart)` re-resolves **all** tables of **all** imported files;
- `analyzer(each_dao.dart)` does the same, again.

Element resolution is expensive: `DartTableResolver._parseColumns` performs one
resolved-AST lookup (`buildStep.resolver.astNodeFor(..., resolve: true)`) **per
column**. On the motivating schema (5 table files, 6 DAOs, 1 database, 420 tables)
a build performs ~1,400 table resolutions ≈ tens of thousands of resolver round
trips.

Measured on that schema (M-series MacBook):

| | stock 2.34.0 | this fork (warm cache) |
|---|---|---|
| full build, drift portion | 593 s of 646 s | ~10–25 s |
| single-column edit, total | 547 s | ~40 s |
| code generation (`modular` phase) | ~4 s | ~4 s (unchanged) |

Codegen was never the bottleneck, which is why this fork caches **analysis only**
(a "Layer 2" per-table snippet cache for generated code was designed, then dropped:
it would save ~4 s at significant complexity).

## 2. The fix: a content-addressed sidecar cache

When `incremental_generation` is on, analysis results for plain tables are
*additionally* stored **outside the build system**, in
`<package>/.dart_tool/drift_incremental_cache/` (configurable via
`incremental_cache_dir`). This intentionally trades build hermeticity for
cross-step reuse; the safety model below makes that trade sound.

### Read path
`DriftAnalyzer` wraps its stock `BuildCacheReader` in an
`IncrementalCacheReader` decorator. `readElementCacheFor(uri)`:

1. defers to the build system first (unchanged stock behavior — later phases keep
   reading real module JSONs);
2. on `null`, reads the sidecar record for the library, reads the library's
   **current source** through the `BuildStep` (which also registers the input
   dependency, keeping rebuild triggering correct), hashes every top-level class
   with the unresolved parser (milliseconds), and synthesizes a module-JSON string
   containing **only the entries whose stored hash matches the current hash**.

Deserialization then flows through the existing, battle-tested
`ElementDeserializer`. Elements absent from the synthesized JSON (changed tables,
new tables, non-table elements) fall back to stock full resolution via a small
change in `DriftResolver._restoreOrResolve` (presence check → silent miss instead
of a logged deserialization error).

### Write path
At the end of every `DriftAnalyzer.build`, each locally-defined, error-free
`DriftTable` is serialized individually (`ElementSerializer.serialize([table])`)
and stored with its source hash. Records are rewritten wholesale per library, so
deleted/renamed tables are pruned automatically. Writes are atomic
(temp file + rename); any IO error is swallowed (the cache must never fail a build).

### The source hash (`source_hasher.dart`)
`sha256` over, in order:

- a **context string** — cache format revision (`incrementalCacheRevision`),
  `Platform.version`, and the full serialized builder options;
- all **directives** of the library (imports change what identifiers resolve to);
- the source text of every same-file top-level declaration the class
  **transitively references** (identifier tokens are collected conservatively —
  over-approximation only causes extra invalidation, never staleness);
- the class's own source text.

Guards that force a miss (→ stock resolution): parse errors; libraries with
`part`/`part of` directives; libraries importing their **own package** or using
relative imports (the hasher can only see one file, so cross-file Dart
dependencies like shared mixins can't be hashed — such libraries are simply never
cached).

### What is never cached (v1 limitations)
- Views, DAOs/accessors, databases, SQL queries, `.drift` files — always
  re-resolved (they're few and cheap relative to tables).
- Tables whose serialized form references resolved Dart types — type converters,
  `customType`, `@UseRowClass` — because those serialize as indices into a
  per-file type-helper library and are not self-contained. They fall back
  per-element with zero correctness impact.

## 3. Safety model

The cache can only affect **speed**, never **output**:

1. Entries are served only on an exact source-hash match (content-addressed).
2. The context hash embeds cache revision + SDK + all builder options; `meta.json`
   mismatch discards the whole directory. Entries written under any other
   configuration can never validate.
3. Every failure path (missing file, malformed JSON, hash mismatch, IO error,
   parse error) degrades to a cache miss = stock full resolution.
4. The builder never reads its own generated `.drift.dart` outputs; output files
   are always produced from a fully materialized element model.
5. Escape hatch: delete the cache directory → next build is byte-equivalent to a
   stock cold build.

Cross-table references remain correct: a cached table's serialized FK references
are re-bound during deserialization to the *current* target element; if the
target changed incompatibly, deserialization fails and the referencing table is
re-resolved in full.

## 4. Changes in this fork

| File | Change |
|---|---|
| `drift_dev/lib/src/backends/build/incremental/incremental_cache.dart` | **new** — sidecar store, context validation, synthesized module JSON, decorator reader |
| `drift_dev/lib/src/backends/build/incremental/source_hasher.dart` | **new** — unresolved parse + per-class transitive source hashing |
| `drift_dev/lib/src/backends/build/incremental/timing.dart` | **new** — `DRIFT_TIMINGS=1` stopwatch logging |
| `drift_dev/lib/src/backends/build/analyzer.dart` | wire decorator + write-back into `DriftAnalyzer.build` |
| `drift_dev/lib/src/analysis/resolver/resolver.dart` | presence check in `_restoreOrResolve` (silent fallback for partial caches) |
| `drift_dev/lib/src/analysis/options.dart` (+ generated `options.g.dart`) | new options `incremental_generation` (bool, default false), `incremental_cache_dir` (string?) |
| `drift_dev/lib/src/backends/build/drift_builder.dart` | timing instrumentation only |
| `drift_dev/test/backends/build/incremental/source_hasher_test.dart` | **new** — 10 unit tests for the hasher |

## 5. Consumer setup

```yaml
# build.yaml
targets:
  $default:
    builders:
      drift_dev:
        enabled: false
      drift_dev:analyzer:
        enabled: true
        generate_for: &drift_sources
          - lib/data/local/**        # wherever your drift code lives
          # plus ANY barrel file a DAO/database uses to reach the tables -
          # drift discovery crawls imports/exports file by file and needs
          # discovery data for every hop:
          - lib/config/config.dart
        options: &options
          incremental_generation: true
          # incremental_cache_dir: tool/drift_cache   # optional: commit a shared warm cache
          # ... your other drift options
      drift_dev:modular:
        enabled: true
        generate_for: *drift_sources
        options: *options
```

Keep `drift_dev` permanently in `dev_dependencies` — removing/re-adding it
invalidates build_runner's own cache and forces cold builds of every builder.

## 6. Verification performed

- **Stock parity**: flag off ⇒ byte-identical output to pub.dev drift_dev 2.34.0
  on a 420-table schema; flag on ⇒ byte-identical to flag-off output.
- **Mutation matrix** (each followed by a build; block-level diff attribution
  confirmed changes confined to the touched tables; untouched files byte-identical):
  add column, remove column, change column type, nullable→non-null and back,
  add table (2 files), rename table, delete table. A full revert reproduced all
  13 generated files byte-for-byte.
- **Hasher unit tests**: determinism, per-class isolation, reference closure,
  top-level constant dependencies, directive sensitivity, context sensitivity,
  unsafe-import detection, syntax-error handling.

## 7. Maintenance

- Bump `incrementalCacheRevision` (in `incremental_cache.dart`) whenever analysis
  or serialization logic changes — it force-invalidates all existing caches.
- Rebasing on upstream: the touch points are small and localized (see table
  above); re-run the parity + mutation verification after any rebase.
- Upstream issue this addresses in practice: simolus3/drift#3306
  (hundreds of tables → builds that never finish).

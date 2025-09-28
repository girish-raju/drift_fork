---
title: Setup
description: All you need to know about adding drift to your project.
---

Drift is a powerful database library for Dart and Flutter applications. To
support its advanced capabilities like type-safe SQL queries, verification of
your database and migrations, it uses a builder and command-line tooling that
runs at compile-time.

This means that the setup involves a little more than just adding a single
dependency to your pubspec. This page explains how to add drift to your project
and gives pointers to the next steps.
If you're stuck adding drift, or have questions or feedback about the project,
please share that with the community by [starting a discussion on GitHub](https://github.com/simolus3/drift/discussions).
If you want to look at an example app for inspiration, a cross-platform Flutter app using drift is available
[as part of the drift repository](https://github.com/simolus3/drift/tree/develop/examples/app).

## The dependencies

First, let's add drift to your project's `pubspec.yaml`.
In addition to the core drift dependencies (`drift` and `drift_dev` to generate code), we're also
adding a package to open database on the respective platform.

<Tabs defaultValue="sqlite3">
  <TabItem label="Flutter (sqlite3)" value="sqlite3_flutter">

```
dependencies:
  drift: ^{{ versions.drift }}
  drift_flutter: ^{{ versions.drift_flutter }}
  path_provider: ^{{ versions.path_provider }}

dev_dependencies:
  drift_dev: ^{{ versions.drift_dev }}
  build_runner: ^{{ versions.build_runner }}
```

Alternatively, you can achieve the same result using the following command:

```
dart pub add drift drift_flutter path_provider dev:drift_dev dev:build_runner
```

</TabItem>
<TabItem label="Dart (sqlite3)" value="sqlite3">

```
dependencies:
  drift: ^{{ versions.drift }}
  sqlite3: ^{{ versions.sqlite3 }}

dev_dependencies:
  drift_dev: ^{{ versions.drift_dev }}
  build_runner: ^{{ versions.build_runner }}
```

Alternatively, you can achieve the same result using the following command:

```
dart pub add drift sqlite3 dev:drift_dev dev:build_runner
```

</TabItem>
<TabItem label="Dart (postgres)" value="postgres">

```
dependencies:
  drift: ^{{ versions.drift }}
  postgres: ^{{ versions.postgres }}
  drift_postgres: ^{{ versions.drift_postgres }}

dev_dependencies:
  drift_dev: ^{{ versions.drift_dev }}
  build_runner: ^{{ versions.build_runner }}
```

Alternatively, you can achieve the same result using the following command:

```
dart pub add drift postgres drift_postgres dev:drift_dev dev:build_runner
```

Drift only generates code for sqlite3 by default. So, also create a `build.yaml`
to <PageRef href="generation_options/index.md">configure</PageRef> `drift_dev`:

```
targets:
  $default:
  builders:
    drift_dev:
    options:
      sql:
        dialects:
          - postgres
          # Uncomment if you need to support both
#         - sqlite
```

</TabItem>
</Tabs>

## Database class

Every project using drift needs at least one class to access a database. This class references all the
tables you want to use and is the central entry point for drift's code generator.
In this example, we'll assume that this database class is defined in a file called `database.dart` and
somewhere under `lib/`. Of course, you can put this class in any Dart file you like.

To make the database useful, we'll also add a simple table to it. This table, `TodoItems`, can be used
to store todo items for a todo list app.
Everything there is to know about defining tables in Dart is described on the <PageRef href="dart_api/tables.md">Dart tables</PageRef> page.
If you prefer using SQL to define your tables, drift supports that too! You can read all about that
<PageRef href="sql_api/index.md">here</PageRef>.

For now, populate the contents of `database.dart` with these tables which could form the persistence
layer of a simple todolist application:

TODO: Snippet

You will get an analyzer warning on the `part` statement and on `extends _$AppDatabase`. This is
expected because drift's generator did not run yet.
You can do that by invoking [build_runner](https://pub.dev/packages/build_runner):

 - `dart run build_runner build` generates all the required code once.
 - `dart run build_runner watch` watches for changes in your sources and generates code with
   incremental rebuilds. This is suitable for development sessions.

After running either command, the `database.g.dart` file containing the generated `_$AppDatabase`
class will have been generated.
You will now see errors related to missing overrides and a missing constructor. The constructor
is responsible for telling drift how to open the database. The `schemaVersion` getter is relevant
for migrations after changing the database, we can leave it at `1` for now. Update `database.dart`
so it now looks like this:

<a name="open"></a>

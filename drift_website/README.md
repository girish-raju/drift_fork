# drift_website

Documentation for the Drift project, built with `jaspr_content`.

## Building the Documentation

To start the website for preview purposes, run

```shell
dart run jaspr_cli:jaspr serve --no-managed-build-options
```

The development server will be available on `http://localhost:8080`.

To build the website, run:

```shell
dart run jaspr_cli:jaspr serve --no-managed-build-options
rm -r build/jaspr/packages build/jaspr/.dart_tool build/jaspr/.build.manifest
```

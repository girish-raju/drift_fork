---

title: Encryption
description: Use drift on encrypted databases

---

There are two ways to use drift on encrypted databases.
The `encrypted_drift` package is similar to `drift_sqflite` and uses a platform plugin written in
Java.
Alternatively, you can use the ffi-based implementation with regular `package:drift/native.dart` APIs.

For new apps, we recommend using a `NativeDatabase` with encrypted databases.
An example of a Flutter app using the new encryption package is available
[here](https://github.com/simolus3/drift/tree/develop/examples/encryption).

## Encrypted version of a `NativeDatabase`

You can use the `drift/native` library with an encrypted executor.
This allows you to use an encrypted drift database on all native platforms, including Desktop.

### Setup

The `sqlite3` package uses build hooks to bundle a version of SQLite with your app.
It can be configured to bundle [SQLite3MultipleCiphers](https://utelle.github.io/SQLite3MultipleCiphers/)
instead, which provides encryption support.
To enable encryption, add this to the pubspec of your pub workspace root (or your app's pubspec if you're
not using pub workspaces):

```yaml
hooks:
  user_defines:
    sqlite3:
      source: sqlite3mc
```

For more information on configuring hooks, see [the documentation](https://pub.dev/documentation/sqlite3/latest/topics/hook-topic.html).

Previous versions of the `sqlite3` package required a dependency on `sqlcipher_flutter_libs`. That package is no longer necessary
after upgrading to drift 2.32.0 and can be removed.

### Using

SQLite3MultipleCiphers implements the SQLite C API, which means that you can continue to use the `sqlite3` package
or `package:drift/native.dart` without code changes.

To actually encrypt a database though, you must set an encryption key before using it.
A good place to do that in drift is the `setup` parameter of `NativeDatabase`, which runs before drift
is using the database in any way:

<Snippet href="/lib/src/snippets/platforms/encryption.dart" name="encrypted1" />

### Important notice

SQLite3MultipleCiphers is a fork of SQLite with added encryption support.
To ensure you're using the right version in your app, it is recommended that you check for the `cipher`
pragma at runtime (since that is not provided by upstream SQLite):

<Snippet href="/lib/src/snippets/platforms/encryption.dart" name="check_cipher" />

Next, add an `assert(_debugCheckHasCipher(database))` before using the database. A suitable place is the
`setup` parameter to a `NativeDatabase`:

<Snippet href="/lib/src/snippets/platforms/encryption.dart" name="encrypted2" />

If this check reveals that the encrypted variant is not available, check your hook options
or open an issue on [this repository](https://github.com/simolus3/sqlite3.dart/) for further advice.

### Encrypting existing databases

If you have an existing database which you now want to encrypt, there are a few steps to consider.
First, add hook options to link SQLite3MultipleCiphers as shown in [setup](#setup).

Note however that you can't just apply the `pragma key = ` statement on existing databases!
To migrate existing databases to encryption, this creates a temporary copy that will be encrypted with [`pragma rekey`](https://utelle.github.io/SQLite3MultipleCiphers/docs/configuration/config_sql_pragmas/#pragma-rekey--hexrekey):

<Snippet href="/lib/src/snippets/platforms/encryption.dart" name="migration" />

### Migrating from SQLCipher to SQLite3MultipleCiphers

Previous versions of this page suggested using `sqlcipher_flutter_libs` and custom code to enable
SQLCipher. Starting from drift version 2.32.0 and version 3.x of the `sqlite3` package, using
SQLite3MultipleCiphers is much easier.

SQLCipher is no longer supported with a straightforward setup. It is possible to use existing encrypted
databases with SQLite3MultipleCiphers. To do that, run the following pragmas before `pragma key`
after upgrading:

1. `PRAGMA cipher = 'sqlcipher'`
2. `PRAGMA legacy = 4`.

Please carefully test that your app supports existing databases after upgrading to SQLite3MultipleCiphers.
For more details, see [this issue](https://github.com/simolus3/sqlite3.dart/issues/302#issuecomment-3765247078).

## Using `encrypted_drift`

In addition to the `dart:ffi`-based encrypted executor based on `package:sqlite3`, we also provide
a version of drift that uses the [sqflite_sqlcipher](https://pub.dev/packages/sqflite_sqlcipher) library
by [@davidmartos96](https://github.com/davidmartos96).

To use it, you need to remove a dependency on `drift_sqflite` you might have in your `pubspec.yaml`
and replace it with this:

```yaml
dependencies:
  drift: ^{{ versions.drift }}
  encrypted_drift:
   git:
    url: https://github.com/simolus3/drift.git
    path: extras/encryption
```

Instead of importing `package:drift_sqflite/drift_sqflite.dart` (or `package:drift/native.dart`) in your apps, 
you would then import both `package:drift/drift.dart` and `package:encrypted_drift/encrypted_drift.dart`.

Finally, you can replace `SqfliteQueryExecutor` (or a `NativeDatabase`) with an `EncryptedExecutor`.

### Extra setup on Android and iOS

Some extra steps may have to be taken in your project so that SQLCipher works correctly. For example, the ProGuard configuration on Android for apps built for release.

[Read instructions](https://pub.dev/packages/sqflite_sqlcipher) (Usage and installation instructions of the package can be ignored, as that is handled internally by `encrypted_drift`)

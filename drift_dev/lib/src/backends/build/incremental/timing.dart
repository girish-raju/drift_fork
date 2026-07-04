import 'dart:io';

import 'package:build/build.dart' show log;

/// Whether verbose timing output for drift's build steps is enabled.
///
/// Timings are printed as `info` logs when the `DRIFT_TIMINGS` environment
/// variable is set to `1`, allowing build performance to be inspected with
/// `DRIFT_TIMINGS=1 dart run build_runner build --verbose`.
final bool driftTimingsEnabled = Platform.environment['DRIFT_TIMINGS'] == '1';

Future<T> timedAsync<T>(String label, Future<T> Function() body) async {
  if (!driftTimingsEnabled) return body();

  final watch = Stopwatch()..start();
  try {
    return await body();
  } finally {
    log.info('[drift-timing] $label: ${watch.elapsedMilliseconds}ms');
  }
}

T timedSync<T>(String label, T Function() body) {
  if (!driftTimingsEnabled) return body();

  final watch = Stopwatch()..start();
  try {
    return body();
  } finally {
    log.info('[drift-timing] $label: ${watch.elapsedMilliseconds}ms');
  }
}

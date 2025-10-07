import 'package:jaspr/jaspr.dart';

import 'web_compatibility_unsupported.dart'
    if (dart.library.js_interop) 'web_compatibility_web.dart';

@client
final class WebCompatibilityCheck extends StatefulComponent {
  @override
  State<StatefulComponent> createState() => _WebCompatibilityCheckState();
}

final class _WebCompatibilityCheckState extends State<WebCompatibilityCheck> {
  Future<String>? _compatibilityResult;

  void startCheck() {
    setState(() {
      _compatibilityResult ??= determineDriftWasmCompatibility();
    });
  }

  @override
  Component build(BuildContext context) {
    return FutureBuilder(
      future: _compatibilityResult,
      builder: (context, snapshot) {
        return div([
          if (_compatibilityResult == null) ...[
            button([text('Check compatibility')]),
            pre([text('Compatibility check not started yet.')]),
          ] else if (snapshot.connectionState == ConnectionState.active)
            progress([])
          else if (snapshot.hasError)
            pre([
              text('Error: ${snapshot.error}, Trace:\n${snapshot.stackTrace}'),
            ])
          else
            pre([text(snapshot.data ?? 'No results available')]),
        ]);
      },
    );
  }
}

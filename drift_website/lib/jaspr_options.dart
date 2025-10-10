// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:drift_website/src/components/anchors.dart' as prefix0;
import 'package:drift_website/src/components/web_compatibility.dart' as prefix1;
import 'package:jaspr_content_snippets/internal/client.dart' as prefix2;
import 'package:jaspr_docsy/internal/tabs.dart' as prefix3;

/// Default [JasprOptions] for use with your jaspr project.
///
/// Use this to initialize jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'jaspr_options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultJasprOptions,
///   );
///
///   runApp(...);
/// }
/// ```
JasprOptions get defaultJasprOptions => JasprOptions(
  clients: {
    prefix0.ActiveAnchors: ClientTarget<prefix0.ActiveAnchors>(
      'src/components/anchors',
    ),

    prefix1.WebCompatibilityCheck: ClientTarget<prefix1.WebCompatibilityCheck>(
      'src/components/web_compatibility',
    ),

    prefix2.CodeBlockCopyButton: ClientTarget<prefix2.CodeBlockCopyButton>(
      'jaspr_content_snippets:internal/client',
    ),

    prefix3.InternalTabHeaders: ClientTarget<prefix3.InternalTabHeaders>(
      'jaspr_docsy:internal/tabs',
      params: _prefix3InternalTabHeaders,
    ),
  },
  styles: () => [],
);

Map<String, dynamic> _prefix3InternalTabHeaders(prefix3.InternalTabHeaders c) =>
    {'items': c.items};

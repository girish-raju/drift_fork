// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:drift_website/src/components/sidebar_toggle_button.dart'
    as prefix0;
import 'package:drift_website/src/components/web_compatibility.dart' as prefix1;
import 'package:jaspr_content/components/_internal/tab_bar.dart' as prefix2;
import 'package:jaspr_content/components/_internal/zoomable_image.dart'
    as prefix3;
import 'package:jaspr_content/components/github_button.dart' as prefix4;
import 'package:jaspr_content/components/image.dart' as prefix5;
import 'package:jaspr_content/components/tabs.dart' as prefix6;
import 'package:jaspr_content_snippets/internal/client.dart' as prefix7;

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
    prefix0.SidebarToggleButton: ClientTarget<prefix0.SidebarToggleButton>(
      'src/components/sidebar_toggle_button',
    ),

    prefix1.WebCompatibilityCheck: ClientTarget<prefix1.WebCompatibilityCheck>(
      'src/components/web_compatibility',
    ),

    prefix2.TabBar: ClientTarget<prefix2.TabBar>(
      'jaspr_content:components/_internal/tab_bar',
      params: _prefix2TabBar,
    ),

    prefix3.ZoomableImage: ClientTarget<prefix3.ZoomableImage>(
      'jaspr_content:components/_internal/zoomable_image',
      params: _prefix3ZoomableImage,
    ),

    prefix4.GitHubButton: ClientTarget<prefix4.GitHubButton>(
      'jaspr_content:components/github_button',
      params: _prefix4GitHubButton,
    ),

    prefix7.CodeBlockCopyButton: ClientTarget<prefix7.CodeBlockCopyButton>(
      'jaspr_content_snippets:internal/client',
    ),
  },
  styles: () => [
    ...prefix2.TabBar.styles,
    ...prefix3.ZoomableImage.styles,

    ...prefix4.GitHubButton.styles,
    ...prefix5.Image.styles,

    ...prefix6.Tabs.styles,
  ],
);

Map<String, dynamic> _prefix2TabBar(prefix2.TabBar c) => {
  'initialValue': c.initialValue,
  'items': c.items,
};
Map<String, dynamic> _prefix3ZoomableImage(prefix3.ZoomableImage c) => {
  'src': c.src,
  'alt': c.alt,
  'caption': c.caption,
};
Map<String, dynamic> _prefix4GitHubButton(prefix4.GitHubButton c) => {
  'repo': c.repo,
};

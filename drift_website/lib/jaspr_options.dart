// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:drift_website/components/clicker.dart' as prefix0;
import 'package:jaspr_content/components/_internal/tab_bar.dart' as prefix1;
import 'package:jaspr_content/components/_internal/zoomable_image.dart'
    as prefix2;
import 'package:jaspr_content/components/image.dart' as prefix3;
import 'package:jaspr_content/components/sidebar_toggle_button.dart' as prefix4;
import 'package:jaspr_content/components/tabs.dart' as prefix5;
import 'package:jaspr_content/components/theme_toggle.dart' as prefix6;
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
    prefix0.Clicker: ClientTarget<prefix0.Clicker>('components/clicker'),

    prefix1.TabBar: ClientTarget<prefix1.TabBar>(
      'jaspr_content:components/_internal/tab_bar',
      params: _prefix1TabBar,
    ),

    prefix2.ZoomableImage: ClientTarget<prefix2.ZoomableImage>(
      'jaspr_content:components/_internal/zoomable_image',
      params: _prefix2ZoomableImage,
    ),

    prefix4.SidebarToggleButton: ClientTarget<prefix4.SidebarToggleButton>(
      'jaspr_content:components/sidebar_toggle_button',
    ),

    prefix6.ThemeToggle: ClientTarget<prefix6.ThemeToggle>(
      'jaspr_content:components/theme_toggle',
    ),

    prefix7.CodeBlockCopyButton: ClientTarget<prefix7.CodeBlockCopyButton>(
      'jaspr_content_snippets:internal/client',
    ),
  },
  styles: () => [
    ...prefix0.ClickerState.styles,
    ...prefix1.TabBar.styles,
    ...prefix2.ZoomableImage.styles,

    ...prefix3.Image.styles,

    ...prefix5.Tabs.styles,
    ...prefix6.ThemeToggleState.styles,
  ],
);

Map<String, dynamic> _prefix1TabBar(prefix1.TabBar c) => {
  'initialValue': c.initialValue,
  'items': c.items,
};
Map<String, dynamic> _prefix2ZoomableImage(prefix2.ZoomableImage c) => {
  'src': c.src,
  'alt': c.alt,
  'caption': c.caption,
};

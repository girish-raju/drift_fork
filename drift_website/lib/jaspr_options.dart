// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:drift_website/components/clicker.dart' as prefix0;
import 'package:jaspr_content/components/_internal/code_block_copy_button.dart'
    as prefix1;
import 'package:jaspr_content/components/_internal/tab_bar.dart' as prefix2;
import 'package:jaspr_content/components/_internal/zoomable_image.dart'
    as prefix3;
import 'package:jaspr_content/components/callout.dart' as prefix4;
import 'package:jaspr_content/components/code_block.dart' as prefix5;
import 'package:jaspr_content/components/image.dart' as prefix6;
import 'package:jaspr_content/components/sidebar_toggle_button.dart' as prefix7;
import 'package:jaspr_content/components/tabs.dart' as prefix8;
import 'package:jaspr_content/components/theme_toggle.dart' as prefix9;

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

    prefix1.CodeBlockCopyButton: ClientTarget<prefix1.CodeBlockCopyButton>(
      'jaspr_content:components/_internal/code_block_copy_button',
    ),

    prefix2.TabBar: ClientTarget<prefix2.TabBar>(
      'jaspr_content:components/_internal/tab_bar',
      params: _prefix2TabBar,
    ),

    prefix3.ZoomableImage: ClientTarget<prefix3.ZoomableImage>(
      'jaspr_content:components/_internal/zoomable_image',
      params: _prefix3ZoomableImage,
    ),

    prefix7.SidebarToggleButton: ClientTarget<prefix7.SidebarToggleButton>(
      'jaspr_content:components/sidebar_toggle_button',
    ),

    prefix9.ThemeToggle: ClientTarget<prefix9.ThemeToggle>(
      'jaspr_content:components/theme_toggle',
    ),
  },
  styles: () => [
    ...prefix0.ClickerState.styles,
    ...prefix2.TabBar.styles,
    ...prefix3.ZoomableImage.styles,
    ...prefix4.Callout.styles,
    ...prefix5.CodeBlock.styles,

    ...prefix6.Image.styles,

    ...prefix8.Tabs.styles,
    ...prefix9.ThemeToggleState.styles,
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

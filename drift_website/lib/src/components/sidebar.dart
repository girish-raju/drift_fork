import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/_internal/icon.dart';

import '../navigation.dart';

final class DriftSidebar extends StatelessComponent {
  const DriftSidebar();

  @override
  Component build(BuildContext context) {
    final tab = DriftTab.current(context) ?? DriftTab.docs;

    return nav(classes: 'sidebar', [
      button(classes: 'sidebar-close', [const CloseIcon(size: 20)]),
      div([for (final group in tab.groups) group]),
    ]);
  }
}

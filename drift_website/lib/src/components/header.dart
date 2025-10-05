import 'package:jaspr/jaspr.dart';

import '../navigation.dart';
import 'sidebar_toggle_button.dart';

final class DriftHeader extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    final currentTab = DriftTab.current(context);

    return header([
      nav([
        div([
          const SidebarToggleButton(),
          a(href: '/', [text('Drift')]),
        ]),
        div([text('test')]),
      ]),
      div(classes: 'tabs', [
        for (final tab in DriftTab.all)
          a(classes: tab == currentTab ? 'active' : '', href: tab.page, [
            text(tab.name),
          ]),
      ]),
    ]);
  }
}

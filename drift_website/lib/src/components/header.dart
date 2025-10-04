import 'package:jaspr/jaspr.dart';

import 'sidebar_toggle_button.dart';

final class DriftHeader extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return header([
      nav([
        div([
          const SidebarToggleButton(),
          a(href: '/', [text('Drift')]),
        ]),
        div([text('test')]),
      ]),
    ]);
  }
}

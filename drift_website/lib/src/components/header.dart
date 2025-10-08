import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/github_button.dart';

import '../navigation.dart';
import 'sidebar_toggle_button.dart';

final class DriftHeader extends StatelessComponent {
  const DriftHeader();

  @override
  Component build(BuildContext context) {
    final currentTab = DriftTab.current(context);

    return header([
      nav([
        div([
          const SidebarToggleButton(),
          a(href: '/', [text('Drift')]),
        ]),
        GitHubButton(repo: 'simolus3/drift'),
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

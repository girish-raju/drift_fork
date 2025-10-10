import 'package:jaspr/jaspr.dart';
import 'package:jaspr_docsy/jaspr_docsy.dart';

import '../navigation.dart';

final class DriftSidebar extends StatelessComponent {
  const DriftSidebar();

  @override
  Component build(BuildContext context) {
    final tab = DriftTab.current(context) ?? DriftTab.docs;

    return Sidebar(
      search: NavbarSearchInput(),
      entries: [
        SidebarEntry(
          href: tab.page,
          title: text(tab.name),
          activePath: true,
          children: [for (final group in tab.groups) group],
        ),
      ],
    );
  }
}

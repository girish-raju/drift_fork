import 'package:jaspr/jaspr.dart';
import 'package:jaspr_docsy/jaspr_docsy.dart';

import '../navigation.dart';
import 'search_input.dart';

final class DriftHeader extends StatelessComponent {
  const DriftHeader();

  @override
  Component build(BuildContext context) {
    final currentTab = DriftTab.current(context);

    return Navbar(
      brand: NavbarBrand(href: '/', title: Component.text('Drift')),
      items: [
        for (final tab in DriftTab.all)
          NavbarLink(
            href: tab.page,
            active: tab == currentTab,
            children: [Component.text(tab.name)],
          ),
        NavbarLink(
          href: 'https://pub.dev/packages/drift',
          active: false,
          children: [Component.text('pub.dev')],
        ),
      ],
      search: const DriftSearchInput(),
    );
  }
}

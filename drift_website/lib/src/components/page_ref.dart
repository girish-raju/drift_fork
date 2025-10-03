import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' show url;

import 'inherited_page.dart';

final class PageRef implements CustomComponent {
  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(
      tag: 'pageref',
      :final children,
      :final attributes,
    )) {
      final href = switch (attributes['href']) {
        null => throw ArgumentError('Missing href attribute'),
        final href => href,
      };

      final child = builder.build(children);
      return _PageLink(ref: href, child: child);
    }

    return null;
  }
}

final class _PageLink extends StatelessComponent {
  final String ref;
  final Component child;

  _PageLink({required this.ref, required this.child});

  @override
  Component build(BuildContext context) {
    final page = context.page;
    final resolvedRef = url.join(url.dirname(page.path), ref);
    final referencedPage = InheritedPageResolver.resolvePageSource(
      context,
      resolvedRef,
    );

    if (referencedPage == null) {
      return strong(styles: Styles(color: Colors.red), [
        text('broken link to $resolvedRef'),
      ]);
    }

    return a(href: referencedPage.url, [child]);
  }
}

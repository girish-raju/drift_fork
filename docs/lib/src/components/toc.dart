import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/jaspr_content.dart' as jaspr;

import 'anchors.dart';

final class TableOfContents extends StatelessComponent {
  const TableOfContents();

  @override
  Component build(BuildContext context) {
    final toc = context.page.data['toc'] as jaspr.TableOfContents?;
    if (toc == null) {
      return const Component.empty();
    }

    return fragment([
      div(classes: 'td-toc', [
        div(classes: 'td-toc__title', [
          span(classes: 'td-toc__title__text', [text('On this page')]),
          a(
            classes: 'td-toc__title__link',
            href: '#',
            attributes: {'title': 'Top of the page'},
            [],
          ),
        ]),
        nav(id: 'TableOfContents', [ActiveAnchors(), toc.render()]),
      ]),
    ]);
  }
}

extension on jaspr.TableOfContents {
  Component render() {
    return ul([..._buildToc(entries)]);
  }

  Iterable<Component> _buildToc(List<TocEntry> toc) sync* {
    for (final entry in toc) {
      yield li([
        a(href: '#${entry.id}', [text(entry.text)]),
        if (entry.children.isNotEmpty) ul([..._buildToc(entry.children)]),
      ]);
    }
  }
}

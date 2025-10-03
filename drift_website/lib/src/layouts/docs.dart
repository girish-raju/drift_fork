import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';

final class DriftDocsLayout extends DocsLayout {
  DriftDocsLayout({super.sidebar, super.header, super.footer});

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page).where((e) => e is! Style);
    yield link(href: '/style.css', rel: 'stylesheet');
  }
}

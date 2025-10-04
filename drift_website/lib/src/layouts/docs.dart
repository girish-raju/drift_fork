import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';

final class LegacyDocsLayout extends DocsLayout {
  LegacyDocsLayout({super.sidebar, super.header, super.footer});

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page).where((e) => e is! Style);
    yield link(href: '/style.css', rel: 'stylesheet');
  }

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;

    return fragment([
      if (this.header case final header?) header,
      div(classes: 'main-container', [
        div(classes: 'sidebar-barrier', attributes: {'role': 'button'}, []),
        if (sidebar case final sidebar?)
          div(classes: 'sidebar-container', [sidebar]),
        main_([
          div([
            div(classes: 'content-container', [
              div(classes: 'content-header', [
                if (pageData['title'] case String title) h1([text(title)]),
                if (pageData['description'] case String description)
                  p([text(description)]),
                if (pageData['image'] case String image)
                  img(src: image, alt: pageData['imageAlt'] as String?),
              ]),
              child,
              if (this.footer case final footer?)
                div(classes: 'content-footer', [footer]),
            ]),
            aside(classes: 'toc', [
              if (page.data['toc'] case TableOfContents toc)
                div([
                  h3([text('On this page')]),
                  toc.build(),
                ]),
            ]),
          ]),
        ]),
      ]),
    ]);
  }
}

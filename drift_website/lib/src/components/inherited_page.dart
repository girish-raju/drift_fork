import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' show url;

final class InheritedPage extends InheritedComponent {
  final Page page;

  const InheritedPage({required super.child, required this.page, super.key});

  static Page of(BuildContext context) {
    return context.dependOnInheritedComponentOfExactType<InheritedPage>()!.page;
  }

  @override
  bool updateShouldNotify(covariant InheritedPage oldComponent) {
    return oldComponent.page != page;
  }
}

/// A [PageLayout] that makes the current page available to inner components.
final class InheritedPageLayout extends PageLayout {
  final PageLayout _inner;

  InheritedPageLayout(this._inner);

  @override
  Component buildLayout(Page page, Component child) {
    return InheritedPage(child: _inner.buildLayout(page, child), page: page);
  }

  @override
  Pattern get name => _inner.name;
}

final class InheritedPageResolver extends InheritedComponent {
  final FilesystemLoader loader;

  InheritedPageResolver({
    required super.child,
    super.key,
    required this.loader,
  });

  static PageSource? resolvePageSource(BuildContext context, String path) {
    final loader = context
        .dependOnInheritedComponentOfExactType<InheritedPageResolver>()!
        .loader;
    final normalized = url.normalize(path);

    for (final page in loader.sources) {
      if (page.path == normalized) {
        return page;
      }
    }

    return null;
  }

  @override
  bool updateShouldNotify(covariant InheritedComponent oldComponent) {
    return false;
  }
}

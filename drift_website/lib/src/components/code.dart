import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content_snippets/jaspr_content_snippets.dart';

final class DriftCodeBlock implements CustomComponent {
  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(
      tag: 'pre',
      children: [ElementNode(tag: 'code', :final children)],
    )) {
      return CodeSnippetContainer(child: builder.build(children));
    }

    return null;
  }
}

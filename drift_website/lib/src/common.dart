import 'package:jaspr_content/jaspr_content.dart';
import 'package:markdown/markdown.dart' as md;

import 'components/admonition.dart';

md.Document driftMarkdownDocumentBuilder() {
  return md.Document(
    blockSyntaxes: [
      ...MarkdownParser.defaultBlockSyntaxes,
      const AdmonitionSyntax(),
    ],
    extensionSet: md.ExtensionSet.gitHubWeb,
  );
}

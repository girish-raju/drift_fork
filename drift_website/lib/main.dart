// The entrypoint for the **server** environment.
//
// The [main] method will only be executed on the server during pre-rendering.
// To run code on the client, use the @client annotation.

// Server-specific jaspr import.
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/tabs.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:jaspr_content_snippets/jaspr_content_snippets.dart';
import 'package:watcher/watcher.dart';

import 'components/clicker.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'jaspr_options.dart';
import 'src/components/code.dart';
import 'src/components/collapsible.dart';
import 'src/components/header.dart';
import 'src/components/inherited_page.dart';
import 'src/components/page_ref.dart';
import 'src/components/sidebar.dart';
import 'src/generated_snippets.dart';
import 'src/layouts/docs.dart';
import 'src/relative_watcher.dart';
import 'src/version_data_loader.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: JasprOptions(
      clients: defaultJasprOptions.clients,
      styles: () => [],
    ),
  );

  final fsLoader = FilesystemLoader(
    'content',
    // ignore: invalid_use_of_visible_for_testing_member
    watcherFactory: (path) {
      final inner = DirectoryWatcher(path);
      // For some reason rebuilds don't work without this, but this must
      // be something I'm doing wrong. Temporary workaround until I figure
      // this out.
      return RelativeDirectoryWatcher(inner);
    },
  );

  runApp(
    InheritedPageResolver(
      loader: fsLoader,
      child: ContentApp.custom(
        loaders: [fsLoader],
        configResolver: PageConfig.all(
          enableFrontmatter: true,
          dataLoaders: [PackageVersionDataLoader()],
          templateEngine: MustacheTemplateEngine(),
          parsers: [MarkdownParser()],
          extensions: [
            // Adds heading anchors to each heading.
            HeadingAnchorsExtension(),
            // Generates a table of contents for each page.
            TableOfContentsExtension(),
          ],
          components: [
            PageRef(),
            // The <Info> block and other callouts.
            //Callout(),
            DriftCodeBlock(),
            Collapsible.component(),
            // Adds a custom Jaspr component to be used as <Clicker/> in markdown.
            CustomComponent(
              pattern: 'Clicker',
              builder: (_, __, ___) => Clicker(),
            ),
            // Adds zooming and caption support to images.
            Image(zoom: true),
            Tabs(),
            renderedSnippetComponent(snippets: generatedSnippets),
          ],
          layouts: [
            DriftDocsLayout(header: DriftHeader(), sidebar: DriftSidebar()),
          ],
          theme: ContentTheme.none(),
        ),
      ),
    ),
  );
}

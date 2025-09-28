import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/theme_toggle.dart';

final class DriftHeader extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return Header(
      title: 'Drift',
      logo: '/images/logo.svg',
      items: [
        a(href: '/foo', [text('Guides')]),
        // Enables switching between light and dark mode.
        ThemeToggle(),
        // Shows github stats.
        //GitHubButton(repo: 'simolus3/drift'),
      ],
    );
  }
}

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/sidebar.dart';

final class DriftSidebar extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return Sidebar(
      groups: [
        // Adds navigation links to the sidebar.
        SidebarGroup(
          links: [
            SidebarLink(text: "Home", href: '/'),
            SidebarLink(text: "Setup guide", href: '/setup'),
            SidebarLink(text: "FAQ", href: '/todo'),
          ],
        ),
        SidebarGroup(
          title: 'Dart reference',
          links: [
            SidebarLink(text: "Defining tables", href: '/todo'),
            SidebarLink(text: "Selects", href: '/todo'),
            SidebarLink(text: "Writes (update, insert, delete)", href: '/todo'),
            SidebarLink(text: "Stream queries", href: '/todo'),
            SidebarLink(text: "Expressions", href: '/todo'),
            SidebarLink(text: "Schema introspection", href: '/todo'),
            SidebarLink(text: "Views", href: '/todo'),
            SidebarLink(text: "DAOs", href: '/todo'),
            SidebarLink(text: "Manager API", href: '/todo'),
          ],
        ),
        SidebarGroup(
          title: 'SQL API reference',
          links: [
            SidebarLink(text: "Getting started", href: '/about'),
            SidebarLink(text: "Drift files", href: '/todo'),
            SidebarLink(text: "Sqlite extensions", href: '/todo'),
            SidebarLink(text: "Custom queries", href: '/todo'),
          ],
        ),
        SidebarGroup(
          title: 'Migrations',
          links: [
            SidebarLink(text: "Overview", href: '/todo'),
            SidebarLink(text: "Testing", href: '/todo'),
            SidebarLink(text: "Helpers", href: '/todo'),
            SidebarLink(text: "Schema exports", href: '/todo'),
          ],
        ),
        SidebarGroup(
          title: 'Platforms',
          links: [
            SidebarLink(text: "Native", href: '/todo'),
            SidebarLink(text: "Web", href: '/todo'),
            SidebarLink(text: "Encryption", href: '/todo'),
            SidebarLink(text: "libsql", href: '/todo'),
            SidebarLink(text: "PostgreSQL", href: '/todo'),
          ],
        ),
        SidebarGroup(
          title: 'Generation options',
          links: [
            SidebarLink(text: "Overview", href: '/todo'),
            SidebarLink(text: "Modular code generation", href: '/todo'),
            SidebarLink(text: "Drift and other builders", href: '/todo'),
          ],
        ),
        SidebarGroup(
          title: 'Advanced topics',
          links: [
            SidebarLink(text: "Isolates", href: '/todo'),
            SidebarLink(text: "Testing", href: '/todo'),
            SidebarLink(text: "Generated table rows", href: '/todo'),
            SidebarLink(text: "Type converters", href: '/todo'),
            SidebarLink(text: "Custom SQL types", href: '/todo'),
          ],
        ),
      ],
    );
  }
}

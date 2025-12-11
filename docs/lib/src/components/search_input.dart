import 'package:jaspr/jaspr.dart';
import 'package:jaspr_docsy/components/search_bar.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

import 'modal.dart';

@client
final class DriftSearchInput extends StatelessComponent {
  const DriftSearchInput();

  @override
  Component build(BuildContext context) {
    return SearchBar(
      events: {
        'click': (e) {
          e.preventDefault();
          context.read(ModalNotifier.provider.notifier).showSearch();
        },
      },
    );
  }
}

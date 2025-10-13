import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

void main() async {
  final old = await _discoverUrls(
    Directory('/home/simon/tmp/drift_site_comparison/old'),
  );

  final newPaths = await _discoverUrls(Directory('build/jaspr'));

  print(
    'Found ${old.length} elements in old site, ${newPaths.length} in new site',
  );

  for (final file in old) {
    if (!newPaths.contains(file)) {
      print('Missing: $file');
    }
  }
}

Future<Set<String>> _discoverUrls(Directory root) async {
  final found = <String>{};

  await for (final entry in root.list(recursive: true)) {
    if (entry is File) {
      if (p.extension(entry.path) == '.html') {
        final path = p.relative(entry.path.toLowerCase(), from: root.path);
        found.add('/$path');
      }
      if (p.basename(entry.path) == '_redirects') {
        await for (final line
            in entry
                .openRead()
                .transform(utf8.decoder)
                .transform(const LineSplitter())) {
          final [oldPath, newPath] = line.split(' ');
          found
            ..add(p.join(oldPath.toLowerCase(), 'index.html'))
            ..add(p.join(newPath.toLowerCase(), 'index.html'));
        }
      }
    }
  }

  return found;
}

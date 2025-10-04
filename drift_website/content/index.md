---
title: Welcome to Drift!
description: Drift is a reactive persistence library for relational data in Dart and Flutter apps.
layout: docs
---

Drift is a reactive persistence library for Dart and Flutter applications. It's built on top
of database libraries like [the sqlite3 package](https://pub.dev/packages/sqlite3), [sqflite](https://pub.dev/packages/sqflite) and others.
Adding to these libraries, drift provides additional features, like:

- __Type safety__: Instead of writing SQL queries manually and parsing the `List<Map<String, dynamic>>` that they
return, drift turns rows into objects of your choice.
- __Stream queries__: Drift lets you "watch" your queries with zero additional effort. Any query can be turned into
 an auto-updating stream that emits new items when the underlying data changes.
- __Fluent queries__: Drift generates Dart methods and classes you can use to write queries and automatically get their results.
 Keep an updated list of all users with `select(users).watch()`. That's it! No SQL to write, no rows to parse.
- __Type-safe SQL__: If you prefer to write SQL, that's fine! Drift has an SQL parser and analyzer built in. It can parse
  your queries at compile time, figure out what columns they're going to return and generate Dart code to represent your
  rows.
- __Migration utils__: Drift makes writing migrations easier thanks to utility functions like `.createAllTables()`.
 You don't need to manually write your `CREATE TABLE` statements and keep them updated.

And much more! Drift validates data before inserting it, so you can get helpful error messages instead of just an
SQL error code. Of course, it supports transactions. And DAOs. And efficient batched insert statements. The list goes on.

## Getting started

To get started with drift, follow the [setup guide](setup.md).
It explains everything from setting up the dependencies to writing database classes
and generating code.

It also links a few pages intended for developers getting started with drift, so
that you can explore the areas you're most interested in first.

## Getting Started

Here are a few things you can do to begin:

*   Explore the features of `jaspr_content` inside `lib/main.dart`.
*   Read the [Quick Start Guide]({{links.quickstart}}) to understand how to set up your content-driven site.
*   Start adding your own content pages in the `content/` directory.

## Showcase

`jaspr_content` supports all standard markdown syntax, allowing you to format your content effectively. It also supports adding custom components like this one:

<Info>
  This is an example of a custom component. You can create your own or use the ones provided by `jaspr_content` to enhance your documentation!

  <Clicker/>
</Info>

### Inline Elements

Use `inline code` for brief mentions of code, **bold text** for emphasis, or *italic text* for highlighting. You can also create [links to external sites]({{links.website}}).

### Blockquotes

> This is a blockquote. It's great for highlighting important information or quotes.
> It has a custom color applied to it using `jaspr_content`s theming capabilities.

### Code Blocks

You can easily include code snippets. `jaspr_content` even comes with syntax highlighting and copy functionality out of the box.

```dart
// lib/main.dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

void main() {
  runApp(ContentApp(
    parsers: [
      MarkdownParser(),
    ],
  ));
}
```

## Images

Displaying images is straightforward:

![Jasper Photo](https://jaspr.site/images/jasper_resized/17.webp)

You can even **zoom-in** by clicking on the image.

## More to Discover!

This is just a placeholder to get things started.

Feel free to explore the [Documentation]({{links.docs}}) to understand the underlying architecture and how you can customize your site further.

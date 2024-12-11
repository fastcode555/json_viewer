# JSON Viewer Guide

English| [简体中文](guide_cn.md) | [Deutsch](guide_de.md) | [Português](guide_pt.md) | [日本語](guide_jp.md) | [한국어](guide_kr.md)

## Introduction

JSON Viewer is a Flutter widget for formatting and displaying JSON data, with support for expanding and collapsing JSON nodes. It is primarily used for viewing API response data in applications.

![Alt](json_shrink_widget/pics/show.gif)

## Installation

Add the dependency in pubspec.yaml:

```yaml
dependencies:
  json_shrink_widget: ^1.2.0
```

## Basic Usage

Simplest way to use:

```dart
JsonShrinkWidget(
  json: jsonString  // Supports String, Map, and List types
)
```

## Advanced Configuration

JsonShrinkWidget supports the following configuration options:

- `shrink`: bool - Whether to collapse by default, defaults to false
- `deep`: int - JSON traversal depth level
- `indentation`: String - Indentation character
- `style`: JsonShrinkStyle - Style configuration
- `deepShrink`: int - Default collapse level
- `showNumber`: bool - Whether to show the number of elements in arrays/objects
- `urlSpanBuilder`: Function - Custom URL link display style

Style configuration example:

```dart
JsonShrinkWidget(
  json: jsonString,
  shrink: true,  // Collapsed by default
  deep: 3,       // Traverse 3 levels
  indentation: "  ",  // Use 2 spaces for indentation
  style: JsonShrinkStyle(
    // Custom styles
    keyStyle: TextStyle(color: Colors.blue),
    valueStyle: TextStyle(color: Colors.black),
    symbolStyle: TextStyle(color: Colors.grey)
  ),
  showNumber: true  // Show element count
)
```

## Features

1. Support for Multiple Data Types
- JSON String
- Map
- List

2. Flexible Display Control
- Click to collapse/expand JSON nodes
- Set default collapse level
- Custom indentation style

3. User-Friendly Visual Effects
- Syntax highlighting
- Formatted alignment
- Optional element count display

4. Custom Configuration
- Style customization
- URL link handling
- Indentation control

## Examples

1. Basic JSON Display:

```dart
String jsonStr = '''
{
  "name": "JSON Viewer",
  "version": "1.2.0",
  "author": "infinity"
}
''';

JsonShrinkWidget(
  json: jsonStr
)
```

2. Styled Configuration:

```dart
JsonShrinkWidget(
  json: jsonData,
  style: JsonShrinkStyle(
    keyStyle: TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold
    ),
    valueStyle: TextStyle(
      color: Colors.black87
    )
  )
)
```

3. Show Array Element Count:

```dart
JsonShrinkWidget(
  json: listData,
  showNumber: true,  // Show array length
  shrink: true      // Collapsed by default
)
```

## Important Notes

1. Input JSON string must be valid JSON format
2. Recommended to set appropriate traversal depth (deep parameter) based on data size
3. For large JSON data, recommended to use collapse mode by default
4. Style configuration fully supports customization according to application theme

## Common Issues

1. JSON Parsing Failure
- Check if JSON string format is correct
- Verify string encoding is UTF-8

2. Performance Issues
- Properly control deep parameter
- Use collapse mode for large data sets

3. Style Issues
- Verify style configuration is correct
- Confirm TextStyle parameters 
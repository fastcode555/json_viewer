# JSON Viewerガイド

[English](guide_en.md) | [简体中文](guide_cn.md) | [Deutsch](guide_de.md) | [Português](guide_pt.md) | 日本語 | [한국어](guide_kr.md)

## はじめに

JSON Viewerは、JSONデータをフォーマットして表示するFlutterウィジェットで、JSONノードの展開と折りたたみをサポートしています。主にアプリケーションでAPIレスポンスデータを表示するために使用されます。

![デモ](pics/show.gif)


## インストール

pubspec.yamlに依存関係を追加します：

```yaml
dependencies:
  json_shrink_widget: ^1.2.0
```

## 基本的な使用方法

最も簡単な使用方法：

```dart
JsonShrinkWidget(
  json: jsonString  // String、Map、List型をサポート
)
```

## 高度な設定

JsonShrinkWidgetは以下の設定オプションをサポートしています：

- `shrink`: bool - デフォルトで折りたたむかどうか、デフォルトはfalse
- `deep`: int - JSONの走査深度レベル
- `indentation`: String - インデント文字
- `style`: JsonShrinkStyle - スタイル設定
- `deepShrink`: int - デフォルトの折りたたみレベル
- `showNumber`: bool - 配列/オブジェクトの要素数を表示するかどうか
- `urlSpanBuilder`: Function - カスタムURLリンク表示スタイル

スタイル設定の例：

```dart
JsonShrinkWidget(
  json: jsonString,
  shrink: true,  // デフォルトで折りたたむ
  deep: 3,       // 3レベル走査
  indentation: "  ",  // 2スペースでインデント
  style: JsonShrinkStyle(
    // カスタムスタイル
    keyStyle: TextStyle(color: Colors.blue),
    valueStyle: TextStyle(color: Colors.black),
    symbolStyle: TextStyle(color: Colors.grey)
  ),
  showNumber: true  // 要素数を表示
)
```

## 機能

1. 複数のデータ型をサポート
- JSON文字列
- Map
- List

2. 柔軟な表示制御
- クリックでJSONノードの折りたたみ/展開
- デフォルトの折りたたみレベル設定
- カスタムインデントスタイル

3. ユーザーフレンドリーな視覚効果
- シンタックスハイライト
- フォーマット済みの整列
- オプションの要素数表示

4. カスタム設定
- スタイルのカスタマイズ
- URLリンクの処理
- インデント制御

## 例

1. 基本的なJSON表示：

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

2. スタイル付きの設定：

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

3. 配列要素数の表示：

```dart
JsonShrinkWidget(
  json: listData,
  showNumber: true,  // 配列の長さを表示
  shrink: true      // デフォルトで折りたたむ
)
```

## 重要な注意事項

1. 入力JSON文字列は有効なJSON形式である必要があります
2. データサイズに基づいて適切な走査深度（deepパラメータ）を設定することを推奨します
3. 大きなJSONデータの場合、デフォルトで折りたたみモードを使用することを推奨します
4. スタイル設定はアプリケーションのテーマに応じて完全にカスタマイズ可能です

## よくある問題

1. JSONパース失敗
- JSON文字列形式が正しいか確認してください
- 文字エンコーディングがUTF-8であることを確認してください

2. パフォーマンスの問題
- deepパラメータを適切に制御してください
- 大きなデータセットには��りたたみモードを使用してください

3. スタイルの問題
- スタイル設定が正しいか確認してください
- TextStyleパラメータを確認してください 
# JSON Viewer Anleitung

[English](guide_en.md) | [简体中文](guide_cn.md) | Deutsch | [Português](guide_pt.md) | [日本語](guide_jp.md) | [한국어](guide_kr.md)

## Einführung

JSON Viewer ist ein Flutter-Widget zum Formatieren und Anzeigen von JSON-Daten mit Unterstützung zum Ein- und Ausklappen von JSON-Knoten. Es wird hauptsächlich zur Anzeige von API-Antwortdaten in Anwendungen verwendet.

![Alt](pics/show.gif)

## Installation

Fügen Sie die Abhängigkeit in pubspec.yaml hinzu:

```yaml
dependencies:
  json_shrink_widget: ^1.2.0
```

## Grundlegende Verwendung

Einfachste Verwendung:

```dart
JsonShrinkWidget(
  json: jsonString  // Unterstützt String-, Map- und List-Typen
)
```

## Erweiterte Konfiguration

JsonShrinkWidget unterstützt die folgenden Konfigurationsoptionen:

- `shrink`: bool - Ob standardmäßig eingeklappt werden soll, Standard ist false
- `deep`: int - JSON-Traversierungstiefe
- `indentation`: String - Einrückungszeichen
- `style`: JsonShrinkStyle - Stilkonfiguration
- `deepShrink`: int - Standard-Einklappebene
- `showNumber`: bool - Ob die Anzahl der Elemente in Arrays/Objekten angezeigt werden soll
- `urlSpanBuilder`: Function - Benutzerdefinierter URL-Link-Anzeigestil

Beispiel für Stilkonfiguration:

```dart
JsonShrinkWidget(
  json: jsonString,
  shrink: true,  // Standardmäßig eingeklappt
  deep: 3,       // 3 Ebenen traversieren
  indentation: "  ",  // 2 Leerzeichen für Einrückung verwenden
  style: JsonShrinkStyle(
    // Benutzerdefinierte Stile
    keyStyle: TextStyle(color: Colors.blue),
    valueStyle: TextStyle(color: Colors.black),
    symbolStyle: TextStyle(color: Colors.grey)
  ),
  showNumber: true  // Elementanzahl anzeigen
)
```

## Funktionen

1. Unterstützung für mehrere Datentypen
- JSON-Zeichenkette
- Map
- List

2. Flexible Anzeigesteuerung
- Klicken zum Ein-/Ausklappen von JSON-Knoten
- Standardmäßige Einklappebene festlegen
- Benutzerdefinierter Einrückungsstil

3. Benutzerfreundliche visuelle Effekte
- Syntaxhervorhebung
- Formatierte Ausrichtung
- Optionale Elementanzahlanzeige

4. Benutzerdefinierte Konfiguration
- Stilanpassung
- URL-Link-Behandlung
- Einrückungssteuerung

## Beispiele

1. Grundlegende JSON-Anzeige:

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

2. Konfiguration mit Stil:

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

3. Array-Elementanzahl anzeigen:

```dart
JsonShrinkWidget(
  json: listData,
  showNumber: true,  // Array-Länge anzeigen
  shrink: true      // Standardmäßig eingeklappt
)
```

## Wichtige Hinweise

1. Die Eingabe-JSON-Zeichenkette muss ein gültiges JSON-Format haben
2. Es wird empfohlen, eine angemessene Traversierungstiefe (deep-Parameter) basierend auf der Datengröße festzulegen
3. Für große JSON-Daten wird empfohlen, standardmäßig den eingeklappten Modus zu verwenden
4. Die Stilkonfiguration unterstützt vollständige Anpassung gemäß dem Anwendungsthema

## Häufige Probleme

1. JSON-Parsing-Fehler
- Überprüfen Sie, ob das JSON-Zeichenkettenformat korrekt ist
- Überprüfen Sie, ob die Zeichenkodierung UTF-8 ist

2. Leistungsprobleme
- Steuern Sie den deep-Parameter angemessen
- Verwenden Sie den eingeklappten Modus für große Datensätze

3. Stilprobleme
- Überprüfen Sie, ob die Stilkonfiguration korrekt ist
- Bestätigen Sie die TextStyle-Parameter 
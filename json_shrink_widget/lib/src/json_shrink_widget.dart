import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_shrink_widget/src/inline_span_ext.dart';
import 'package:json_shrink_widget/src/json_formatter.dart';
import 'package:json_shrink_widget/src/json_shrink_style.dart';

/// @date 26/7/22
/// describe: 支持json 收缩或者展开
class JsonShrinkWidget extends StatefulWidget {
  //支持String,支持List，支持Map
  final dynamic json;

  //是否收缩，默认为false
  final bool? shrink;

  //遍历的Json的层级
  final int deep;

  //缩进符号
  final String indentation;

  //需要格式化的样式风格
  final JsonShrinkStyle style;

  //作为子级，包含了key值
  final String jsonKey;

  //是否需要添加结束符号，
  final bool needAddSymbol;

  //默认底基层就缩起
  final int deepShrink;

  final ValueChanged<bool>? shrinkCallBack;

  ///回调图片链接，方便用户定制化
  final InlineSpan Function(String url, JsonShrinkStyle style)? urlSpanBuilder;

  const JsonShrinkWidget({
    this.json,
    this.shrink,
    this.deep = 0,
    this.indentation = " ",
    this.style = const JsonShrinkStyle(),
    this.jsonKey = "",
    this.needAddSymbol = false,
    this.deepShrink = 99,
    this.shrinkCallBack,
    this.urlSpanBuilder,
    Key? key,
  }) : super(key: key);

  @override
  _JsonShrinkWidgetState createState() => _JsonShrinkWidgetState();
}

class _JsonShrinkWidgetState extends State<JsonShrinkWidget> {
  bool _shrink = false;
  final List<InlineSpan> _spans = [];
  bool _isList = false;

  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _shrink = widget.shrink ?? widget.deep >= widget.deepShrink;
    _parseSpans(widget.json);
  }

  @override
  void didUpdateWidget(covariant JsonShrinkWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isError = false;
    if (oldWidget.shrink != widget.shrink) {
      _shrink = widget.shrink ?? widget.deep >= widget.deepShrink;
    }
    if (oldWidget.json != widget.json) {
      _spans.clear();
      _parseSpans(widget.json);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Text(widget.json.toString());
    }
    return Text.rich(
      TextSpan(children: _shrink ? _buildShrinkSpan() : _spans),
      textAlign: TextAlign.left,
    );
  }

  ///创建收缩起来的面板
  List<InlineSpan> _buildShrinkSpan() {
    InlineSpan startSpan = _spans[0];
    InlineSpan endSpan = _spans[_spans.length - 1];
    TextSpan? startTextSpan;
    TextSpan? endTextSpan;
    if (startSpan is TextSpan) {
      startTextSpan = startSpan;
    }
    if (endSpan is TextSpan) {
      endTextSpan = endSpan;
    }

    String? text = startTextSpan?.text?.trim();
    String? endText = endTextSpan?.text?.trim();
    String startSymbol = text == '{' || text == '[' ? '' : (_isList ? '[' : '{');
    String endSymbol = _isList ? ']' : '}';
    return [
      startSpan,
      if (widget.jsonKey.isNotEmpty) TextSpan(text: '"${widget.jsonKey}"', style: widget.style.keyStyle),
      TextSpan(
          text: '${widget.jsonKey.isNotEmpty ? ': ' : ''}$startSymbol...$endSymbol',
          style: widget.style.symbolStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                _shrink = false;
              });
              widget.shrinkCallBack?.call(_shrink);
            }),
      if (endText != '}' && endText != ']') endSpan,
      //_changeLineSpan,
    ];
  }

  ///添加更多操作的面板
  void _addOperationPanel(List<InlineSpan> spans) {
    spans.add(
      WidgetSpan(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              child: const Icon(
                Icons.remove_circle_outline,
                color: Colors.grey,
                size: 16,
              ),
              onTap: () {
                setState(() => _shrink = true);
                widget.shrinkCallBack?.call(_shrink);
              },
            ),
            const SizedBox(width: 4),
            GestureDetector(
              child: const Icon(
                Icons.content_copy_rounded,
                color: Colors.grey,
                size: 16,
              ),
              onTap: () => Clipboard.setData(ClipboardData(text: JsonFormatter.format(widget.json))),
            ),
            const SizedBox(width: 4),
            if (kDebugMode)
              GestureDetector(
                onTap: () => debugPrint(JsonFormatter.format(widget.json)),
                child: const Icon(
                  Icons.print,
                  color: Colors.grey,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
    spans.add(const TextSpan(text: "\n"));
  }

  ///解析出Span的功能
  void _parseSpans(dynamic data) {
    _isError = false;
    //解析List
    if (data is List) {
      _isList = true;
      if (data.isEmpty) _shrink = false;
      _spans.addAll(_parseList(
        data,
        deep: widget.deep,
        style: widget.style,
        indentation: widget.indentation,
        key: widget.jsonKey,
      ));
      if (widget.needAddSymbol) {
        _spans.add(TextSpan(text: ",", style: widget.style.symbolStyle));
      }
    } else if (data is Map) {
      //解析map
      _isList = false;
      if (data.isEmpty) _shrink = false;
      _spans.addAll(_parseMap(
        data,
        deep: widget.deep,
        style: widget.style,
        indentation: widget.indentation,
        key: widget.jsonKey,
      ));
      if (widget.needAddSymbol) {
        _spans.add(TextSpan(text: ",", style: widget.style.symbolStyle));
      }
    } else if (data is String) {
      try {
        dynamic json = jsonDecode(data);
        _parseSpans(json);
      } catch (e) {
        print(e);
        _isError = true;
      }
    }
  }

  ///解析Map
  List<InlineSpan> _parseMap(
    Map data, {
    required JsonShrinkStyle style,
    int deep = 0,
    String indentation = " ",
    String key = "",
  }) {
    final TextSpan symbolSpan = TextSpan(text: indentation * deep, style: style.indentationStyle);
    final TextSpan spaceSpan = TextSpan(text: indentation * (deep + 1), style: style.indentationStyle);
    List<InlineSpan> spans = [];
    if (key.isNotEmpty) {
      spans.add(symbolSpan);
      spans.add(TextSpan(text: "\"$key\"", style: style.keyStyle));
      spans.add(TextSpan(text: ': {', style: style.symbolStyle));
    } else {
      spans.add(symbolSpan);
      spans.add(TextSpan(text: '{', style: style.symbolStyle));
    }
    _addOperationPanel(spans);
    List<dynamic> keys = data.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      Object? obj = data[key];
      bool needAddSymbol = true;
      if (obj == null) {
        spans.add(spaceSpan);
        spans.add(TextSpan(text: "\"$key\"", style: style.keyStyle));
        spans.add(TextSpan(text: ': ', style: style.symbolStyle));
        spans.add(TextSpan(text: "$obj", style: style.symbolStyle));
      } else if (obj is String) {
        spans.addString(key, obj, style, spaceSpan, widget.urlSpanBuilder);
      } else if (obj is num) {
        spans.addNum(key, obj, style, spaceSpan);
      } else if (obj is bool) {
        spans.addBool(key, obj, style, spaceSpan);
      } else if (obj is Map || obj is List) {
        needAddSymbol = false;
        spans.add(WidgetSpan(
          child: JsonShrinkWidget(
            json: obj,
            deep: deep + 1,
            indentation: indentation,
            style: style,
            jsonKey: key,
            deepShrink: widget.deepShrink,
            needAddSymbol: i != keys.length - 1,
            urlSpanBuilder: widget.urlSpanBuilder,
          ),
        ));
        spans.add(const TextSpan(text: "\n"));
      }
      if (needAddSymbol) {
        if (i != keys.length - 1) {
          spans.add(TextSpan(text: ",\n", style: style.symbolStyle));
        } else {
          spans.add(TextSpan(text: "\n", style: style.symbolStyle));
        }
      }
    }
    spans.add(symbolSpan);
    spans.add(TextSpan(text: '}', style: style.symbolStyle));
    return spans;
  }

  ///解析列表
  List<InlineSpan> _parseList(
    List<dynamic> data, {
    required JsonShrinkStyle style,
    int deep = 0,
    String indentation = " ",
    String key = "",
  }) {
    final TextSpan symbolSpan = TextSpan(text: indentation * deep, style: style.indentationStyle);
    final TextSpan spaceSpan = TextSpan(text: indentation * (deep + 1), style: style.indentationStyle);
    List<InlineSpan> spans = [];
    if (data.isEmpty) {
      if (key.isNotEmpty) {
        return [
          symbolSpan,
          TextSpan(
            text: "\"$key\"",
            style: style.keyStyle,
            children: [TextSpan(text: ': [ ]', style: style.symbolStyle)],
          )
        ];
      }
      return [
        symbolSpan,
        TextSpan(text: "[ ]", style: style.symbolStyle),
      ];
    }
    //解析list
    if (key.isNotEmpty) {
      spans.add(symbolSpan);
      spans.add(TextSpan(text: "\"$key\"", style: style.keyStyle));
      spans.add(TextSpan(text: ': [', style: style.symbolStyle));
    } else {
      spans.add(symbolSpan);
      spans.add(TextSpan(text: "[", style: style.symbolStyle));
    }
    _addOperationPanel(spans);
    for (int i = 0; i < data.length; i++) {
      Object? obj = data[i];
      bool needAddSymbol = true;
      if (obj == null) {
        spans.add(spaceSpan);
        spans.add(TextSpan(text: "$obj", style: style.numberStyle));
      } else if (obj is num) {
        spans.add(spaceSpan);
        spans.add(TextSpan(text: "$obj", style: style.numberStyle));
      } else if (obj is String) {
        if (isUrl(obj)) {
          String value = obj;
          spans.add(spaceSpan);
          if (widget.urlSpanBuilder != null) {
            spans.add(widget.urlSpanBuilder!(value, style));
          } else {
            spans.add(
              TextSpan(
                text: '"$value"',
                style: style.urlStyle,
                recognizer: LongPressGestureRecognizer()
                  ..onLongPress = () => Clipboard.setData(ClipboardData(text: value)),
              ),
            );
          }
        } else {
          spans.add(spaceSpan);
          spans.add(TextSpan(text: '"$obj"', style: style.textStyle));
        }
      } else if (obj is bool) {
        spans.add(spaceSpan);
        spans.add(TextSpan(text: "$obj", style: style.boolStyle));
      } else if (obj is Map || obj is List) {
        needAddSymbol = false;
        spans.add(WidgetSpan(
          child: JsonShrinkWidget(
            json: obj,
            deep: deep + 1,
            indentation: indentation,
            style: style,
            deepShrink: widget.deepShrink,
            needAddSymbol: i != data.length - 1,
            urlSpanBuilder: widget.urlSpanBuilder,
          ),
        ));
        spans.add(const TextSpan(text: "\n"));
      }
      if (needAddSymbol) {
        if (i != data.length - 1) {
          spans.add(TextSpan(text: ",\n", style: style.symbolStyle));
        } else {
          spans.add(TextSpan(text: "\n", style: style.symbolStyle));
        }
      }
    }
    if (spans[spans.length - 1] is WidgetSpan) {
      spans.add(TextSpan(text: '\n', style: style.symbolStyle));
      spans.add(symbolSpan);
      spans.add(TextSpan(text: ']', style: style.symbolStyle));
    } else {
      spans.add(symbolSpan);
      spans.add(TextSpan(text: ']', style: style.symbolStyle));
    }
    return spans;
  }
}

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
  final JsonShrinkStyle? style;

  //作为子级，包含了key值
  final String jsonKey;

  //是否需要添加结束符号，
  final bool needAddSymbol;

  //默认底基层就缩起
  final int deepShrink;

  final ValueChanged<bool>? shrinkCallBack;

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
    Key? key,
  }) : super(key: key);

  @override
  _JsonShrinkWidgetState createState() => _JsonShrinkWidgetState();
}

const _changeLineSpan = WidgetSpan(child: SizedBox(width: double.infinity));

class _JsonShrinkWidgetState extends State<JsonShrinkWidget> {
  bool _shrink = false;
  final List<InlineSpan> _spans = [];
  bool _isList = false;

  @override
  void initState() {
    super.initState();
    _shrink = widget.shrink ?? widget.deep >= widget.deepShrink;
    _parseSpans(widget.json);
  }

  @override
  void didUpdateWidget(covariant JsonShrinkWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shrink != widget.shrink) {
      _shrink = widget.shrink ?? widget.deep >= widget.deepShrink;
    }
    if (oldWidget.json != widget.json) {
      _parseSpans(widget.json);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: _shrink ? _buildShrinkSpan() : _spans,
      ),
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
    String startSymbol = text == "{" || text == "[" ? "" : (_isList ? "[" : "{");
    String endSymbol = _isList ? "]" : "}";
    return [
      startSpan,
      TextSpan(
          text: '${widget.jsonKey.isNotEmpty ? ":" : ""}$startSymbol...$endSymbol',
          style: widget.style?.symbolStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                _shrink = false;
              });
              widget.shrinkCallBack?.call(_shrink);
            }),
      if (endTextSpan?.text?.trim() != "}" && endTextSpan?.text?.trim() != "]") endSpan,
      _changeLineSpan,
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
        _spans.add(TextSpan(text: ",", style: widget.style?.symbolStyle));
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
        _spans.add(TextSpan(text: ",", style: widget.style?.symbolStyle));
      }
    } else if (data is String) {
      dynamic json = jsonDecode(data);
      _parseSpans(json);
    }
  }

  ///解析Map
  List<InlineSpan> _parseMap(
    Map data, {
    JsonShrinkStyle? style,
    int deep = 0,
    String indentation = " ",
    String key = "",
  }) {
    String symbolSpace = indentation * deep;
    String space = indentation * (deep + 1);
    List<InlineSpan> spans = [];
    if (key.isNotEmpty) {
      spans.add(TextSpan(text: "$symbolSpace\"$key\"", style: style?.keyStyle));
      spans.add(TextSpan(text: ':{', style: style?.symbolStyle));
    } else {
      spans.add(TextSpan(text: "$symbolSpace{", style: style?.symbolStyle));
    }
    _addOperationPanel(spans);
    List<dynamic> keys = data.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      Object? obj = data[key];
      bool needAddSymbol = true;
      if (obj == null) {
        spans.add(TextSpan(text: "$space\"$key\"", style: style?.keyStyle));
        spans.add(TextSpan(text: ":", style: style?.symbolStyle));
        spans.add(TextSpan(text: "$obj", style: style?.symbolStyle));
      } else if (obj is String) {
        spans.addString(key, obj, style, space);
      } else if (obj is num) {
        spans.addNum(key, obj, style, space);
      } else if (obj is bool) {
        spans.addBool(key, obj, style, space);
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
          ),
        ));
        spans.add(_changeLineSpan);
        spans.add(const TextSpan(text: "\n"));
      }
      if (needAddSymbol) {
        if (i != keys.length - 1) {
          spans.add(TextSpan(text: ",\n", style: style?.symbolStyle));
        } else {
          spans.add(TextSpan(text: "\n", style: style?.symbolStyle));
        }
      }
    }
    spans.add(TextSpan(text: "$symbolSpace}", style: style?.symbolStyle));
    return spans;
  }

  ///解析列表
  List<InlineSpan> _parseList(
    List<dynamic> data, {
    JsonShrinkStyle? style,
    int deep = 0,
    String indentation = " ",
    String key = "",
  }) {
    String symbolSpace = indentation * deep;
    String space = indentation * (deep + 1);
    List<InlineSpan> spans = [];
    if (data.isEmpty) {
      if (key.isNotEmpty) {
        return [
          TextSpan(
            text: "$symbolSpace\"$key\"",
            style: style?.keyStyle,
            children: [TextSpan(text: ':[ ]', style: style?.symbolStyle)],
          )
        ];
      }
      return [TextSpan(text: "$symbolSpace[ ]", style: style?.symbolStyle)];
    }
    //解析list
    if (key.isNotEmpty) {
      spans.add(TextSpan(text: "$symbolSpace\"$key\"", style: style?.keyStyle));
      spans.add(TextSpan(text: ':[', style: style?.symbolStyle));
    } else {
      spans.add(TextSpan(text: "$symbolSpace[", style: style?.symbolStyle));
    }
    _addOperationPanel(spans);
    for (int i = 0; i < data.length; i++) {
      Object? obj = data[i];
      bool needAddSymbol = true;
      if (obj == null) {
        spans.add(TextSpan(text: "$space$obj", style: style?.numberStyle));
      } else if (obj is num) {
        spans.add(TextSpan(text: "$space$obj", style: style?.numberStyle));
      } else if (obj is String) {
        spans.add(TextSpan(text: '$space"$obj"', style: style?.textStyle));
      } else if (obj is bool) {
        spans.add(TextSpan(text: "$space$obj", style: style?.boolStyle));
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
          ),
        ));
        spans.add(_changeLineSpan);
        spans.add(const TextSpan(text: "\n"));
      }
      if (needAddSymbol) {
        if (i != data.length - 1) {
          spans.add(TextSpan(text: ",\n", style: style?.symbolStyle));
        } else {
          spans.add(TextSpan(text: "\n", style: style?.symbolStyle));
        }
      }
    }
    if (spans[spans.length - 1] is WidgetSpan) {
      spans.add(TextSpan(text: '\n$symbolSpace]', style: style?.symbolStyle));
    } else {
      spans.add(TextSpan(text: '$symbolSpace]', style: style?.symbolStyle));
    }
    return spans;
  }
}

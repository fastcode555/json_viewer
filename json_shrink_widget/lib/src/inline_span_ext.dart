import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_shrink_widget/src/json_span_style.dart';

///更新正则,已匹配转义后的链接
final RegExp _regexUrl =
    RegExp(r"(https?|ftp|file):(//|\\/\\/)[-A-Za-z0-9+&@#/\%?\\/=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"); //匹配url

bool isUrl(String content) => _regexUrl.hasMatch(content);

bool isImageUrl(String url) {
  String finalUrl = url.toLowerCase();
  return finalUrl.contains(".jpg") || finalUrl.contains('.png') || finalUrl.contains(".jpeg");
}

extension InlineSpanExt on List<InlineSpan> {
  void addString(String key, String value, JsonSpanStyle? style, String space) {
    add(TextSpan(text: '$space"$key"', style: style?.keyStyle));
    add(TextSpan(text: ':', style: style?.symbolStyle));
    if (isUrl(value)) {
      if (isImageUrl(value)) {
        String imageUrl = value.replaceAll('\\/', '/');
        add(
          WidgetSpan(
            child: GestureDetector(
              child: CachedNetworkImage(imageUrl: imageUrl, width: 30, height: 30, fit: BoxFit.cover),
              onLongPress: () => Clipboard.setData(ClipboardData(text: imageUrl)),
            ),
          ),
        );
      } else {
        add(
          TextSpan(
            text: '"$value"',
            style: style?.urlStyle,
            recognizer: LongPressGestureRecognizer()..onLongPress = () => Clipboard.setData(ClipboardData(text: value)),
          ),
        );
      }
    } else {
      add(TextSpan(text: '"$value"', style: style?.textStyle));
    }
  }

  void addNum(String key, num value, JsonSpanStyle? style, String space) {
    add(TextSpan(text: '$space"$key"', style: style?.keyStyle));
    add(TextSpan(text: ':', style: style?.symbolStyle));
    add(TextSpan(text: '$value', style: style?.numberStyle));
  }

  void addBool(String key, bool value, JsonSpanStyle? style, String space) {
    add(TextSpan(text: '$space"$key"', style: style?.keyStyle));
    add(TextSpan(text: ':', style: style?.symbolStyle));
    add(TextSpan(text: '$value', style: style?.boolStyle));
  }
}

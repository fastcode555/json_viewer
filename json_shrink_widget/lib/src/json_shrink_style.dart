import 'package:flutter/material.dart';

/// @date 25/7/22
/// describe:
class JsonShrinkStyle {
  //花括号的颜色
  final TextStyle? symbolStyle;

  //字段名的颜色
  final TextStyle? keyStyle;

  //数字的颜色
  final TextStyle? numberStyle;

  //bool值的风格
  final TextStyle? boolStyle;

  //普通字符串需要显示的颜色
  final TextStyle? textStyle;

  //超链接的颜色
  final TextStyle? urlStyle;

  //图片的大小
  final Size size;

  const JsonShrinkStyle({
    this.symbolStyle = const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    this.keyStyle = const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
    this.numberStyle = const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
    this.textStyle = const TextStyle(color: Colors.white),
    this.urlStyle = const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
    this.boolStyle = const TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold),
    this.size = const Size(50, 50),
  });

  const JsonShrinkStyle.light({
    this.symbolStyle = const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    this.keyStyle = const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
    this.numberStyle = const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
    this.textStyle = const TextStyle(color: Colors.black),
    this.urlStyle = const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
    this.boolStyle = const TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold),
    this.size = const Size(50, 50),
  });
}

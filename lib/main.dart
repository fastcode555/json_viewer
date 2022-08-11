import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:json_shrink_widget/json_shrink_widget.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'JsonViewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const _json =
    '{"condition":{"id":"Ximalaya20441024"},"albumInfo":{"id":76222,"tags":["漢语"]},"trackList":[{"down_load_url":"https://m36.super-music.cc/audiobook/Ximalaya87705385/Ximalaya20441024/track/63818453.m4a?v=6f236a8e499aafe4b0b05ac4907c947d"}]}';

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController()..text = _json;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: "Please input the json text!"),
                ),
              ),
              TextButton(onPressed: () => _controller.clear(), child: const Text("Clear")),
              TextButton(onPressed: () => setState(() {}), child: const Text("Format")),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: JsonShrinkWidget(
                json: _controller.text,
                style: const JsonShrinkStyle.light(),
                urlSpanBuilder: (String url, JsonShrinkStyle style) {
                  if (isImageUrl(url)) {
                    return WidgetSpan(child: ExtendedImage.network(url, width: 30, height: 30, fit: BoxFit.cover));
                  }
                  return TextSpan(text: "\"$url\"", style: style.urlStyle);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isImageUrl(String url) {
    String finalUrl = url.toLowerCase();
    return finalUrl.contains(".jpg") ||
        finalUrl.contains('.png') ||
        finalUrl.contains(".jpeg") ||
        finalUrl.contains(".webp");
  }
}

import 'dart:convert';

import 'package:tools/page/common/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class JsonToolViewMode extends BaseViewModel {
  String errorTips = "";

  JsonToolViewMode(BuildContext context) : super(context);

  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.lightBlue,
    Colors.green,
    Colors.amber,
    Colors.blue,
    Colors.purple,
    Colors.indigo,
    Colors.blueGrey,
    Colors.indigoAccent,
    Colors.brown,
    Colors.cyan,
    Colors.lightGreen,
    Colors.orangeAccent,
    Colors.deepPurpleAccent,
  ];

  void init() {}

  Color getColor(String name) {
    return colors[name.hashCode % colors.length];
  }

  String formatJson(text) {
    //格式化json
    try {
      Map<String, dynamic> jsonMap = json.decode(text);
      text = JsonEncoder.withIndent('  ').convert(jsonMap);
      errorTips = "";
    } catch (e) {
      errorTips = "json格式错误，请检查";
    }
    notifyListeners();
    return text;
  }

  String removeEscapes(String text) {
    return text.replaceAll(r'\\', r"\").replaceAll(r'\"', '"');
  }

  String unicode2Chinese(String text) {
    String pattern = r'\\u([0-9a-fA-F]{4})';
    RegExp regex = RegExp(pattern);
    String decodedString = text.replaceAllMapped(regex, (Match match) {
      var group = match.group(1);
      if (group != null) {
        int code = int.parse(group!, radix: 16);
        return String.fromCharCode(code);
      }
      return "";
    });
    return decodedString;
  }
}

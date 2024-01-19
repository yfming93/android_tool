import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tools/page/common/base_view_model.dart';
import 'package:xml/xml.dart';

class XmlToolsViewMode extends BaseViewModel {
  String errorTips = "";

  XmlToolsViewMode(BuildContext context) : super(context);

  void init() {}

  String formatXml(String htmlText) {
    var xmlDocument = XmlDocument.parse(htmlText);
    return xmlDocument.toXmlString(pretty: true);
  }
}

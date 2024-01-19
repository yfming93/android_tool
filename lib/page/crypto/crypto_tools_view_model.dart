import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:tools/page/common/base_view_model.dart';
import 'package:xml/xml.dart';

class CryptoToolsViewMode extends BaseViewModel {
  List<CryptoRadioModel> cryptoTypeList = [
    CryptoRadioModel(0, "base64"),
    CryptoRadioModel(1, "md5"),
    CryptoRadioModel(2, "urlEncode"),
  ];

  String errorTips = "";

  CryptoToolsViewMode(BuildContext context) : super(context);

  void init() {}

  String formatXml(String htmlText) {
    var xmlDocument = XmlDocument.parse(htmlText);
    return xmlDocument.toXmlString(pretty: true);
  }

  String encode(String text, int selectIndex) {
    String result = "";
    switch (selectIndex) {
      case 0:
        result = base64Encode(utf8.encode(text));
        break;
      case 1:
        result = md5.convert(utf8.encode(text)).toString();
        break;
      case 2:
        result = Uri.encodeFull(text);
        break;
    }
    return result;
  }

  String decode(String text, int selectIndex) {
    String result = "";
    switch (selectIndex) {
      case 0:
        result = utf8.decode(base64Decode(text));
        break;
      case 1:
        result = "md5不能解密";
        break;
      case 2:
        result = Uri.decodeFull(text);
        break;
    }

    return result;
  }
}

class CryptoRadioModel {
  int value = 0;
  String label = "";

  CryptoRadioModel(this.value, this.label);
}

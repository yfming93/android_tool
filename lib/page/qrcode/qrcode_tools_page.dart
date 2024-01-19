import 'dart:io';
import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tools/page/common/base_page.dart';
import 'package:tools/page/qrcode/qrcode_tools_view_model.dart';
import 'package:tools/widget/text_view.dart';
import 'package:helpers/helpers/transition.dart';
import 'dart:ui' as ui;

class QRCodeToolsPage extends StatefulWidget {
  const QRCodeToolsPage({
    Key? key,
  }) : super(key: key);

  @override
  _QRCodeToolsPageState createState() => _QRCodeToolsPageState();
}

class _QRCodeToolsPageState
    extends BasePage<QRCodeToolsPage, QRCodeToolsViewMode> {
  var inputController = TextEditingController();
  GlobalKey globalKey = GlobalKey();

  String _data = "";

  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget contentView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: inputController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10)),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        child: const Text("生成"),
                        onPressed: () {
                          _data = inputController.text;
                          setState(() {});
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        child: const Text("保存图片"),
                        onPressed: () {
                          _saveQRCode();
                        }),
                  ],
                ),
                OpacityTransition(
                  visible: _data.isNotEmpty,
                  child: Center(
                    child: RepaintBoundary(
                      key: globalKey,
                      child: Container(
                        color: Colors.white,
                        child: QrImageView(
                          data: _data,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  createViewModel() {
    return QRCodeToolsViewMode(
      context,
    );
  }

  _saveQRCode() async {
    String? directoryPath = (await getSaveLocation(suggestedName: "qrcode.png"))?.path;
    if (directoryPath == null) {
      return;
    }
    var currentContext = globalKey.currentContext;
    if (currentContext != null) {
      RenderRepaintBoundary renderObject =
          currentContext.findRenderObject() as RenderRepaintBoundary;
      var image = await renderObject.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      var asUint8List = byteData!.buffer.asUint8List();
      XFile xFile = XFile.fromData(asUint8List);
      await xFile.saveTo(directoryPath);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tools/page/common/base_page.dart';
import 'package:tools/page/xml_tools/xml_tools_view_model.dart';

class XmlToolsPage extends StatefulWidget {
  const XmlToolsPage({
    Key? key,
  }) : super(key: key);

  @override
  _FeaturePageState createState() => _FeaturePageState();
}

class _FeaturePageState extends BasePage<XmlToolsPage, XmlToolsViewMode> {
  var inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget contentView(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Selector<XmlToolsViewMode, String>(
                builder: (_, errorTips, __) {
                  return Text(
                    errorTips,
                    style: TextStyle(color: Colors.redAccent),
                  );
                },
                selector: (_, viewModel) => viewModel.errorTips),
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 0, right: 8),
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      inputController.text =
                          viewModel.formatXml(inputController.text);
                    },
                    child: const Text("格式化"),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: inputController.text));
                    },
                    child: const Text("复制"),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 16, bottom: 0, right: 8),
              child: TextField(
                controller: inputController,
                keyboardType: TextInputType.multiline,
                maxLines: 999,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10)),
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  createViewModel() {
    return XmlToolsViewMode(
      context,
    );
  }
}

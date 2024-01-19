import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tools/page/common/base_page.dart';
import 'package:tools/page/crypto/crypto_tools_view_model.dart';

class CryptoToolsPage extends StatefulWidget {
  const CryptoToolsPage({
    Key? key,
  }) : super(key: key);

  @override
  _FeaturePageState createState() => _FeaturePageState();
}

class _FeaturePageState extends BasePage<CryptoToolsPage, CryptoToolsViewMode> {
  var inputController = TextEditingController();
  var outPutController = TextEditingController();
  var _selectIndex = 0;

  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget contentView(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Wrap(
                    children: viewModel.cryptoTypeList
                        .map((model) => IntrinsicWidth(
                            child: RadioListTile(
                                title: Text(model.label),
                                value: model.value,
                                groupValue: _selectIndex,
                                onChanged: (int? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectIndex = value;
                                    });
                                  }
                                })))
                        .toList(),
                  ),
                  Expanded(
                      child: Container(
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.only(
                              left: 16, bottom: 8, right: 8),
                          height: double.infinity,
                          child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 999,
                              controller: inputController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(10))),
                        )),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    outPutController.text = viewModel.encode(
                                        inputController.text, _selectIndex);
                                  },
                                  icon: Icon(Icons.keyboard_double_arrow_right),
                                  label: Text("加密")),
                              TextButton.icon(
                                  onPressed: () {
                                    inputController.text = viewModel.decode(
                                        outPutController.text, _selectIndex);
                                  },
                                  icon: Icon(Icons.keyboard_double_arrow_left),
                                  label: Text("解密"))
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.only(
                              left: 16, bottom: 8, right: 8),
                          child: TextField(
                            controller: outPutController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 999,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10)),
                          ),
                        ))
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ],
        ));
  }

  @override
  createViewModel() {
    return CryptoToolsViewMode(
      context,
    );
  }
}

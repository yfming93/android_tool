import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tools/page/common/base_page.dart';
import 'package:tools/page/json_tools/json_tools_view_model.dart';
import 'package:tools/widget/text_view.dart';

class JsonToolsPage extends StatefulWidget {
  const JsonToolsPage({
    Key? key,
  }) : super(key: key);

  @override
  _JsonToolsPageState createState() => _JsonToolsPageState();
}

class _JsonToolsPageState extends BasePage<JsonToolsPage, JsonToolViewMode> {
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
            Selector<JsonToolViewMode, String>(
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
                          viewModel.formatJson(inputController.text);
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
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      inputController.text =
                          viewModel.removeEscapes(inputController.text);
                    },
                    child: const Text("去除转义"),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      inputController.text =
                          viewModel.unicode2Chinese(inputController.text);
                    },
                    child: const Text("Unicode转中文"),
                  )
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
            )),
            // Expanded(
            //     child: SingleChildScrollView(
            //   child: Container(
            //       padding: const EdgeInsets.only(left: 16, bottom: 0, right: 8),
            //       child: JsonViewer(
            //           json:
            //               '{"name": "John", "age": 30, "car": {"model": "ABC", "year": 2022}, "interests": ["football", "music", "movies"]}')),
            // ))
          ],
        ),
      ),
    );
  }

  Widget titleView(String title) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: viewModel.getColor(title),
              borderRadius: BorderRadius.circular(5),
            )),
        const SizedBox(width: 5),
        TextView(title),
      ],
    );
  }

  Widget buttonView(IconData icon, String title, Function() onPressed) {
    Color color = viewModel.getColor(title);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            // color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.5),
                        color.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              TextView(
                title,
              )
            ],
          ),
        ),
      ),
    );
    // return Expanded(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: MaterialButton(
    //       height: 45,
    //       color: Colors.blue,
    //       onPressed: onPressed,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10.0),
    //       ),
    //       child: ,
    //     ),
    //   ),
    // );
  }

  Container _featureCardView({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Ink(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }

  @override
  createViewModel() {
    return JsonToolViewMode(
      context,
    );
  }
}

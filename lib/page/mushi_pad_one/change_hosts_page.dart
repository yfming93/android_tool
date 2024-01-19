import 'package:flutter/material.dart';

import '../common/app.dart';
import '../common/base_page.dart';
import '../main/main_view_model.dart';

class ChangeHostsPage extends StatefulWidget {
  const ChangeHostsPage({Key? key}) : super(key: key);

  @override
  State<ChangeHostsPage> createState() => _ChangeHostsPageState();
}

class _ChangeHostsPageState extends BasePage<ChangeHostsPage,MainViewModel> {

  final TextEditingController _textEditingController = TextEditingController();

  Future<void> _restoreHostsContent() async{
    var res = await App().getHostsFileContent();
    setState(() {
      _textEditingController.text = res;
    });
  }
  Future<void> _saveHostsContent() async{
    String hostsFileContent = _textEditingController.text;
    App().setHostsFileContent(hostsFileContent);
  }
  Future<void> _readHostsContent() async{
    var res = await viewModel.execAdb(['shell','cat','/system/etc/hosts']);
    debugPrint('---> _ChangeHostsPageState._saveHostsContent res: ${res}');
    setState(() {
      _textEditingController.text = res?.stdout.toString() ?? '';
    });
  }
  Future<void> _writeHostsContent() async{
    viewModel.execAdb(['root']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['remount']);
    await Future.delayed(const Duration(seconds: 1));
    var res = await viewModel.execAdb(['shell','echo','\'${_textEditingController.text}\'','>','/system/etc/hosts']);
    if ((res?.exitCode ?? -1) == 0){
      viewModel.showResultDialog(title: '提示',content: '成功写入');
    }else{
      viewModel.showResultDialog(title: '提示',content: '成功失败');
    }
  }


  @override
  void initState() {
    super.initState();
    viewModel.init();
    _restoreHostsContent();
  }

  @override
  Widget contentView(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: TextField(
                maxLines: 20,
                controller: _textEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                ),
              ),
            ),
            Wrap(
              children: [
                TextButton(onPressed: _saveHostsContent, child: const Text('保存到本地')),
                TextButton(onPressed: _readHostsContent, child: const Text('读取设备hosts文件')),
                TextButton(onPressed: _writeHostsContent, child: const Text('写入')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  createViewModel() {
    return MainViewModel(context);
  }
}

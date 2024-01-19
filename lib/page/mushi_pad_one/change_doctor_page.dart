import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:provider/provider.dart';

import '../../widget/text_view.dart';
import '../common/app.dart';
import '../common/base_page.dart';
import '../main/main_view_model.dart';

class ChangeDoctorPage extends StatefulWidget {
  const ChangeDoctorPage({Key? key}) : super(key: key);

  @override
  State<ChangeDoctorPage> createState() => _ChangeDoctorPageState();
}

class _ChangeDoctorPageState extends BasePage<ChangeDoctorPage, MainViewModel> {
  final DoctorSettingController controller = DoctorSettingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.init().then((value) {
      controller.textController.text = viewModel.doctorApkPath;
    });
  }

  @override
  Widget contentView(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextView("设置Doctor安装包路径", fontSize: 18),
              const SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const TextView(
                    "Doctor安装包路径：",
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Container(
                      height: 28,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              controller: controller.textController,
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                hintText: "请输入或选择Doctor安装包",
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                              ),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final typeGroup = XTypeGroup(label: 'adb', extensions: []);
                              final file = await openFile(acceptedTypeGroups: [typeGroup]);
                              controller.textController.text = file?.path ?? "";
                            },
                            child: const Icon(
                              Icons.folder_open,
                              color: Colors.black38,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // SizedBox(
                  //   height: 30,
                  //   child: OutlinedButton(
                  //     style: ButtonStyle(
                  //       side: MaterialStateProperty.all(
                  //           const BorderSide(color: Colors.grey)),
                  //     ),
                  //     onPressed: () {
                  //       controller.testAdb();
                  //     },
                  //     child: const TextView("测试"),
                  //   ),
                  // ),
                ],
              ),
              Consumer<DoctorSettingController>(builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextView(value.resultText, color: value.resultColor),
                );
              }),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Colors.black12,
                dashPattern: const [4, 2],
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: DropTarget(
                    onDragDone: (details) async {
                      var path = details.files.first.path;
                      path = path.isEmpty ? controller.textController.text : path;
                      controller.textController.text = path;
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(height: 50),
                        Center(
                          child: Icon(
                            Icons.insert_drive_file,
                            color: Colors.grey,
                            size: 100,
                          ),
                        ),
                        SizedBox(height: 15),
                        TextView(
                          "请将Doctor安装包文件拖拽到此处",
                          color: Colors.grey,
                        ),
                        SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                height: 45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue,
                minWidth: double.infinity,
                onPressed: () async {
                  controller.save(context);
                },
                child: const TextView(
                  "保存",
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                height: 45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue,
                minWidth: double.infinity,
                onPressed: () async {
                  replaceApkAndResetSystem();
                },
                child: const TextView(
                  "替换",
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  createViewModel() {
    return MainViewModel(context);
  }

  Future<void> replaceApkAndResetSystem() async{
    String doctorApkFilePath = viewModel.doctorApkPath;

    debugPrint('---> _ChangeDoctorPageState.replaceApkAndResetSystem doctorApkFilePath: ${doctorApkFilePath}');
    viewModel.execAdb(['root']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['remount']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['shell','rm','/system/app/CusCommonService/CusCommonService.apk']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['push',doctorApkFilePath,'/system/app/CusCommonService/']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['shell','am','broadcast','-a','com.android.action.SHOW_NAVIGATION_BAR']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['shell','am','start','-a','android.settings.SETTINGS']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['shell','input','swipe','100','1000','100','100']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['shell','input','tap','300','1050']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['shell','input','tap','300','750']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['shell','input','tap','400','440']);
    await Future.delayed(const Duration(seconds: 1));
    viewModel.execAdb(['shell','input','tap','1000','1050']);
    await Future.delayed(const Duration(seconds: 1));
    // viewModel.execAdb(['shell','input','tap','1000','350']);
  }

}

class DoctorSettingController extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();

  String resultText = "";
  Color resultColor = Colors.black38;

  Future<bool> testAdb() async {
    if (textController.text.isEmpty) {
      resultText = "请先选择或输入ADB路径";
      resultColor = Colors.red;
      notifyListeners();
      return false;
    }
    try {
      var result = await Shell().runExecutableArguments(textController.text, ["version"]);
      if (result.exitCode != 0 || result.outLines.isEmpty) {
        resultText = "请确认ADB路径是否正确";
        resultColor = Colors.red;
        notifyListeners();
        return false;
      }
      resultText = result.outText;
      resultColor = Colors.green;
      notifyListeners();
      return true;
    } catch (e) {
      resultText = "请确认ADB路径是否正确";
      resultColor = Colors.red;
      notifyListeners();
      return false;
    }
  }

  Future<void> save(BuildContext context) async {
    await App().setDoctorApkPath(textController.text);
    notifyListeners();
  }

}
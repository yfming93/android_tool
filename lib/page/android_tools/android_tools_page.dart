import 'package:tools/page/android_log/android_log_page.dart';
import 'package:tools/page/android_tools/devices_model.dart';
import 'package:tools/page/common/base_page.dart';
import 'package:tools/page/feature_page/feature_page.dart';
import 'package:tools/page/flie_manager/file_manager_page.dart';
import 'package:tools/widget/adb_setting_dialog.dart';
import 'package:tools/widget/text_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'android_tools_view_model.dart';

class AndroidToolsPage extends StatefulWidget {
  const AndroidToolsPage({Key? key}) : super(key: key);

  @override
  _AndroidToolsPageState createState() => _AndroidToolsPageState();
}

class _AndroidToolsPageState
    extends BasePage<AndroidToolsPage, AndroidToolsViewModel>
    with SingleTickerProviderStateMixin {
  List<String> titleList = [
    "快捷功能",
    "文件管理",
    "LogCat",
    "设置ADB",
  ];

  late TabController tabController;

  @override
  initState() {
    super.initState();
    viewModel.init();
    tabController = TabController(length: titleList.length, vsync: this);
  }

  @override
  Widget contentView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("安卓工具"),
        actions: [
          devicesView(),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: _buildItem(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: _buildContent(),
          ))
        ],
      ),
    );
  }

  List<Widget> _buildItem() {
    return titleList
        .map((e) => Tab(
              text: e,
            ))
        .toList();
  }

  // Container _featureCardView({required Widget child}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.black12),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     child: Ink(
  //       color: Colors.white,
  //       padding: const EdgeInsets.all(10),
  //       child: child,
  //     ),
  //   );
  // }

  // @override
  // Widget contentView(BuildContext context) {
  //   var select = context.watch<AndroidToolsViewModel>().selectedIndex;
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("安卓工具"),
  //     ),
  //     body: Row(
  //       children: <Widget>[
  //         DropTarget(
  //           onDragDone: (details) {
  //             viewModel.onDragDone(details);
  //           },
  //           child: Container(
  //             color: Colors.blue.withOpacity(0.05),
  //             width: 200,
  //             child: Column(
  //               children: [
  //                 const SizedBox(height: 20),
  //                 Image.asset("images/app_icon.png", width: 60, height: 60),
  //                 devicesView(),
  //                 const SizedBox(height: 20),
  //                 // const Divider(height: 1),
  //                 // _leftItem("images/ic_devices_info.svg", "设备信息", 0),
  //                 _leftItem("images/ic_quick_future.svg", "快捷功能", 1),
  //                 _leftItem("images/ic_folder.svg", "文件管理", 2),
  //                 _leftItem("images/ic_log.svg", "LogCat", 3),
  //                 _leftItem("images/ic_settings.svg", "设置", 4),
  //                 _leftItem("images/ic_settings.svg", "JSON工具", 5),
  //                 _leftItem("images/ic_quick_future.svg", "安卓工具", 1),
  //               ],
  //             ),
  //           ),
  //         ),
  //         // const VerticalDivider(width: 1),
  //         Expanded(
  //           child: Column(
  //             children: [
  //               // packageNameView(context, select),
  //               Expanded(
  //                 child: buildContent(select),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  List<Widget> _buildContent() {
    List<Widget> result = [];
    for (int value = 0; value < titleList.length; value++) {
      if (value == 0) {
        result.add(FeaturePage(
          deviceId: viewModel.deviceId,
        ));
      } else if (value == 1) {
        result.add(FileManagerPage(viewModel.deviceId));
      } else if (value == 2) {
        result.add(AndroidLogPage(deviceId: viewModel.deviceId));
      } else if (value == 3) {
        result.add(AdbSettingDialog(viewModel.adbPath));
      }
    }
    return result;
  }

  // Widget buildContent(int value) {
  //   // if (value == 0) {
  //   //   return DevicesInfoPage(
  //   //     deviceId: viewModel.deviceId,
  //   //     packageName: viewModel.packageName,
  //   //   );
  //   // } else
  //   if (value == 1) {
  //     return FeaturePage(
  //       deviceId: viewModel.deviceId,
  //     );
  //   } else if (value == 2) {
  //     return FileManagerPage(viewModel.deviceId);
  //   } else if (value == 3) {
  //     return AndroidLogPage(deviceId: viewModel.deviceId);
  //   } else if (value == 4) {
  //     return AdbSettingDialog(viewModel.adbPath);
  //   } else if (value == 5) {
  //     return JsonToolsPage();
  //   } else {
  //     return Container();
  //   }
  // }

  Widget _leftItem(String image, String name, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          viewModel.onLeftItemClick(index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: index == viewModel.selectedIndex
                ? Colors.blue.withOpacity(0.32)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                image,
                width: 23,
                height: 23,
              ),
              const SizedBox(width: 10),
              TextView(name),
            ],
          ),
        ),
      ),
    );
  }

  Widget devicesView() {
    return InkWell(
      onTap: () {
        viewModel.devicesSelect(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 10),
          Selector<AndroidToolsViewModel, DevicesModel?>(
            selector: (context, viewModel) => viewModel.device,
            builder: (context, device, child) {
              return Container(
                constraints: const BoxConstraints(
                  maxWidth: 150,
                ),
                child: Text(
                  device?.itemTitle ?? "未连接设备",
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF666666),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget buttonView(IconData icon, String title, Function() onPressed) {
    Color color = Colors.black;
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

  @override
  createViewModel() {
    return AndroidToolsViewModel(context);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tools/page/android_tools/android_tools_page.dart';
import 'package:tools/page/common/base_page.dart';
import 'package:tools/page/crypto/crypto_tools_page.dart';
import 'package:tools/page/json_tools/json_tools_page.dart';
import 'package:tools/page/qrcode/qrcode_tools_page.dart';
import 'package:tools/page/xml_tools/xml_tools_page.dart';
import 'package:tools/widget/text_view.dart';

import 'main_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BasePage<MainPage, MainViewModel> {
  @override
  initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget contentView(BuildContext context) {
    var select = context.watch<MainViewModel>().selectedIndex;
    return Row(
      children: <Widget>[
        Container(
          color: Colors.blue.withOpacity(0.05),
          width: 200,
          child: Column(
            children: [
              const SizedBox(height: 20),
              // const Divider(height: 1),
              // _leftItem("images/ic_devices_info.svg", "设备信息", 0),
              _leftItem("images/ic_quick_future.svg", "安卓工具", 0),
              _leftItem("images/ic_folder.svg", "JSON工具", 1),
              _leftItem("images/ic_folder.svg", "html/xml格式化", 2),
              _leftItem("images/ic_folder.svg", "常用加密解密", 3),
              _leftItem("images/ic_folder.svg", "二维码生成", 4),
              _leftItem("images/ic_folder.svg", "正则", 5),
              _leftItem("images/ic_folder.svg", "IOS图标生成", 6),
              _leftItem("images/ic_folder.svg", "字符操作", 7), // （串驼峰 下划线等）
            ],
          ),
        ),
        // const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            children: [
              // packageNameView(context, select),
              Expanded(
                child: buildContent(select),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildContent(int value) {
    switch (value) {
      case 0:
        return const AndroidToolsPage();
      case 1:
        return const JsonToolsPage();
      case 2:
        return const XmlToolsPage();
      case 3:
        return const CryptoToolsPage();
      case 4:
        return const QRCodeToolsPage();
      default:
        return Container();
    }
  }

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

  @override
  createViewModel() {
    return MainViewModel(context);
  }
}

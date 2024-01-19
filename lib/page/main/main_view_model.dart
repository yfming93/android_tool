import 'package:tools/page/android_tools/devices_model.dart';
import 'package:tools/page/common/base_view_model.dart';
import 'package:tools/widget/list_filter_dialog.dart';

class MainViewModel extends BaseViewModel {
  ListFilterController<DevicesModel> devicesController = ListFilterController();

  List<DevicesModel> devicesList = [];
  DevicesModel? device;

  int selectedIndex = 0;

  MainViewModel(context) : super(context);

  String get deviceId => device?.id ?? "";

  init() async {}

  void onLeftItemClick(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

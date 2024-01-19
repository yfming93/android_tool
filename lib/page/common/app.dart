import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  static final App _app = App._();

  App._();

  factory App() => _app;

  static const String deviceIdKey = "deviceIdKey";
  static const String packageNameKey = "packageNameKey";
  static const String adbFilePathKey = "adbFilePathKey";
  static const String doctorApkPathKey = "doctorApkPathKey";
  static const String hostsFileContentKey = "hostsFileContentKey";

  final EventBus eventBus = EventBus();

  String _deviceId = "";

  String _packageName = "";

  String _adbPath = "";

  String _doctorApkPath = "";

  String _hostsFileContent = "";

  /// 保存设备ID
  Future<void> setDeviceId(String deviceId) async {
    _deviceId = deviceId;
    eventBus.fire(DeviceIdEvent(deviceId));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(deviceIdKey, deviceId);
  }

  /// 获取设备ID
  Future<String> getDeviceId() async {
    if (_deviceId.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      _deviceId = prefs.getString(deviceIdKey) ?? "";
    }
    return _deviceId;
  }

  /// 保存包名
  Future<void> setPackageName(String packageName) async {
    _packageName = packageName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(packageNameKey, packageName);
  }

  /// 获取包名
  Future<String> getPackageName() async {
    if (_packageName.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      _packageName = prefs.getString(packageNameKey) ?? "";
    }
    return _packageName;
  }

  /// 保存ADB路径
  Future<void> setAdbPath(String path) async {
    _adbPath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(adbFilePathKey, path);
    eventBus.fire(AdbPathEvent(path));
  }

  /// 获取ADB缓存路径
  Future<String> getAdbPath() async {
    if (_adbPath.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      _adbPath = prefs.getString(adbFilePathKey) ?? "";
    }
    return _adbPath;
  }


  /// 保存Doctor安装包路径
  Future<void> setDoctorApkPath(String path) async {
    _doctorApkPath = path;
    final prefs = await SharedPreferences.getInstance();
    var res = await prefs.setString(doctorApkPathKey, path);
    eventBus.fire(DoctorApkPathEvent(path));
  }

  /// 获取doctor安装包路径
  Future<String> getDoctorApkPath() async {
    if (_doctorApkPath.isEmpty){
      final prefs = await SharedPreferences.getInstance();
      _doctorApkPath = prefs.getString(doctorApkPathKey) ?? "";
    }
    return _doctorApkPath;
  }

  /// 保存Hosts文件内容
  Future<void> setHostsFileContent(String content)async{
    _hostsFileContent = content;
    final prefs = await SharedPreferences.getInstance();
    var res = await prefs.setString(hostsFileContentKey, content);
  }
  /// 读取Hosts文件内容
  Future<String> getHostsFileContent() async {
    if (_hostsFileContent.isEmpty){
      final prefs = await SharedPreferences.getInstance();
      _hostsFileContent = prefs.getString(hostsFileContentKey) ?? "";
    }
    return _hostsFileContent;
  }
}

class DeviceIdEvent {
  String deviceId;

  DeviceIdEvent(this.deviceId);
}

class AdbPathEvent {
  String path;

  AdbPathEvent(this.path);
}

class DoctorApkPathEvent {
  String path;

  DoctorApkPathEvent(this.path);
}
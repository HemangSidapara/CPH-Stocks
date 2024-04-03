import 'package:flutter/services.dart';

class InstallApkService {
  static const _platform = MethodChannel('AndroidMethodChannel');
  static InstallApkService instance = InstallApkService();

  Future<bool> installApk() async {
    final isInstalled = await _platform.invokeMethod('installApk');
    return isInstalled;
  }
}

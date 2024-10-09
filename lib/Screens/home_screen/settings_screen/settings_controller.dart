import 'dart:io';

import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/services/utils_services/get_package_info_service.dart';
import 'package:cph_stocks/Network/services/utils_services/install_apk_service.dart';
import 'package:cph_stocks/Screens/home_screen/home_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SettingsController extends GetxController {
  RxString appVersion = ''.obs;
  HomeController homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  ExpansionTileController expansionTileController = ExpansionTileController();
  RxBool isGujaratiLang = false.obs;
  RxBool isHindiLang = false.obs;
  RxBool isUpdateLoading = false.obs;
  RxInt downloadedProgress = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    if (getString(AppConstance.languageCode) == 'gu') {
      isGujaratiLang.value = true;
      isHindiLang.value = false;
    } else if (getString(AppConstance.languageCode) == 'hi') {
      isGujaratiLang.value = false;
      isHindiLang.value = true;
    } else if (getString(AppConstance.languageCode) == 'en') {
      isGujaratiLang.value = false;
      isHindiLang.value = false;
    } else {
      isGujaratiLang.value = false;
      isHindiLang.value = false;
    }
    if (getData(AppConstance.role) != AppConstance.admin && getData(AppConstance.role) != AppConstance.employee) {
      await homeController.getLatestVersionApiCall();
    }
    appVersion.value = (await GetPackageInfoService.instance.getInfo()).version;
  }

  /// Download and install
  Future<void> downloadAndInstallService() async {
    try {
      isUpdateLoading(true);
      final directory = await getExternalStorageDirectory();
      final downloadPath = '${directory?.path}/app-release.apk';

      if (Get.find<HomeController>().newAPKUrl.value.isNotEmpty) {
        final downloadUrl = Get.find<HomeController>().newAPKUrl.value;
        final response = await Dio().downloadUri(
          Uri.parse(downloadUrl),
          downloadPath,
          onReceiveProgress: (counter, total) {
            if (total != -1) {
              if (kDebugMode) {
                print("Downloaded % :: ${(counter / total * 100).toStringAsFixed(0)}%");
              }
              downloadedProgress.value = (counter / total * 100).toStringAsFixed(0).toInt();
            }
          },
        );

        if (response.statusCode == 200) {
          File file = File(downloadPath);
          if (await file.exists()) {
            await InstallApkService.instance.installApk();
            Utils.handleMessage(message: 'Downloaded successfully!');
          } else {
            Utils.handleMessage(message: 'Downloaded file not found.', isError: true);
          }
        } else {
          Utils.handleMessage(message: 'Failed to update.', isError: true);
        }
      } else {
        Utils.handleMessage(message: 'Failed to download.', isError: true);
      }
    } finally {
      isUpdateLoading(false);
    }
  }
}

import 'dart:io';

import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/auth_models/backup_model.dart';
import 'package:cph_stocks/Network/services/auth_services/auth_services.dart';
import 'package:cph_stocks/Network/services/utils_services/install_apk_service.dart';
import 'package:cph_stocks/Screens/home_screen/home_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class SettingsController extends GetxController {
  RxString appVersion = ''.obs;
  HomeController homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  ExpansibleController expansionTileController = ExpansibleController();
  RxBool isGujaratiLang = false.obs;
  RxBool isHindiLang = false.obs;
  RxBool isUpdateLoading = false.obs;
  RxInt downloadedProgress = 0.obs;

  RxBool isBackupLoading = false.obs;
  RxDouble backupProgress = 0.0.obs;

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
    appVersion.value = (await PackageInfo.fromPlatform()).version;
  }

  /// Download Backup
  Future<void> downloadBackup() async {
    try {
      isBackupLoading(true);
      final response = await AuthServices.downloadBackupService();
      if (response.isSuccess) {
        BackupModel backupModel = BackupModel.fromJson(response.response?.data ?? {});
        final currentDate = DateTime.now();
        final downloadPath = "/storage/emulated/0/Download/${"cph_backup_${DateFormat("yyyy_MM_dd_HH_mm_ss").format(currentDate)}.${backupModel.downloadUrl?.split('.').last}"}";
        final downloadResponse = await Dio().download(
          backupModel.downloadUrl ?? "",
          downloadPath,
          onReceiveProgress: (count, total) {
            backupProgress.value = ((count * 100) / total);
          },
        );
        if (downloadResponse.statusCode! >= 200 && downloadResponse.statusCode! <= 299) {
          Utils.handleMessage(message: AppStrings.backupDownloadSuccess.tr);
        } else {
          Utils.handleMessage(message: AppStrings.somethingWentWrong.tr, isError: true);
        }
      }
    } finally {
      isBackupLoading(false);
      backupProgress(0.0);
    }
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

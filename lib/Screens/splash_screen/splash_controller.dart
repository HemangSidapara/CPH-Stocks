import 'dart:async';
import 'dart:io';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/auth_models/get_latest_version_model.dart';
import 'package:cph_stocks/Network/services/auth_services/auth_services.dart';
import 'package:cph_stocks/Network/services/utils_services/get_package_info_service.dart';
import 'package:cph_stocks/Network/services/utils_services/install_apk_service.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Utils/in_app_update_dialog_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SplashController extends GetxController {
  RxString newAPKUrl = ''.obs;
  RxString newAPKVersion = ''.obs;
  RxBool isUpdateLoading = false.obs;
  RxInt downloadedProgress = 0.obs;
  RxString currentVersion = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.SECONDARY_COLOR,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: AppColors.SECONDARY_COLOR,
      statusBarIconBrightness: Brightness.light,
    ));

    await _getLatestVersion().then((value) {
      newAPKUrl(value.$1 ?? '');
      newAPKVersion(value.$2 ?? '');
    });

    newAPKUrl.addListener(GetStream(
      onListen: () async {
        currentVersion.value = (await GetPackageInfoService.instance.getInfo()).version;
        debugPrint('currentVersion :: ${currentVersion.value}');
        debugPrint('newVersion :: ${newAPKVersion.value}');
        if (newAPKUrl.value.isNotEmpty && newAPKVersion.value.isNotEmpty) {
          if (Utils.isUpdateAvailable(currentVersion.value, newAPKVersion.value)) {
            await showUpdateDialog(
              onUpdate: () async {
                await _downloadAndInstall();
              },
              isUpdateLoading: isUpdateLoading,
              downloadedProgress: downloadedProgress,
            );
          } else {
            nextScreenRoute();
          }
        } else {
          nextScreenRoute();
        }
      },
    ));
  }

  /// Next Screen Route
  Future<void> nextScreenRoute() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.SECONDARY_COLOR,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.TRANSPARENT,
        statusBarBrightness: Brightness.light,
      ),
    );
    debugPrint("token value ::: ${getData(AppConstance.authorizationToken)}");
    if (getData(AppConstance.authorizationToken) == null) {
      Get.offAllNamed(Routes.signInScreen);
    } else {
      Get.offAllNamed(Routes.homeScreen);
    }
  }

  /// Get latest Version on server
  Future<(String?, String?)> _getLatestVersion() async {
    final response = await AuthServices.getLatestVersionService();
    GetLatestVersionModel versionModel = GetLatestVersionModel.fromJson(response.response?.data);
    if (response.isSuccess) {
      return (versionModel.data?.firstOrNull?.appUrl, versionModel.data?.firstOrNull?.appVersion);
    }
    return (null, null);
  }

  /// Download and install
  Future<void> _downloadAndInstall() async {
    try {
      isUpdateLoading(true);
      final directory = await getExternalStorageDirectory();
      final downloadPath = '${directory?.path}/app-release.apk';

      if (newAPKUrl.value.isNotEmpty) {
        final downloadUrl = newAPKUrl.value;
        final response = await Dio().downloadUri(
          Uri.parse(downloadUrl),
          downloadPath,
          onReceiveProgress: (counter, total) {
            if (total != -1) {
              debugPrint("Downloaded % :: ${(counter / total * 100).toStringAsFixed(0)}%");
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

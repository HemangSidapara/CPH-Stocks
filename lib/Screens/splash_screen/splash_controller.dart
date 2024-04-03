import 'dart:async';
import 'dart:io';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/auth_models/get_latest_version_model.dart';
import 'package:cph_stocks/Network/services/auth_services/auth_services.dart';
import 'package:cph_stocks/Network/services/utils_services/get_package_info_service.dart';
import 'package:cph_stocks/Network/services/utils_services/install_apk_service.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashController extends GetxController {
  RxString newAPKUrl = ''.obs;
  RxString newAPKVersion = ''.obs;
  RxBool isUpdateLoading = false.obs;
  RxInt downloadedProgress = 0.obs;

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
        if (newAPKUrl.value.isNotEmpty && newAPKVersion.value.isNotEmpty) {
          final currentVersion = (await GetPackageInfoService.instance.getInfo()).version;
          debugPrint('currentVersion :: $currentVersion');
          debugPrint('newVersion :: ${newAPKVersion.value}');

          if (isLatestVersion(currentVersion, newAPKVersion.value)) {
            nextScreenRoute();
          } else {
            await showUpdateDialog();
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

  /// Current app is latest or not
  bool isLatestVersion(String currentVersion, String newAPKVersion) {
    return int.parse(currentVersion.split('.').last.length == 1 ? '${currentVersion.replaceAll('.', '')}0' : currentVersion.replaceAll('.', '')) >= int.parse(newAPKVersion.split('.').last.length == 1 ? '${newAPKVersion.replaceAll('.', '')}0' : newAPKVersion.replaceAll('.', ''));
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

  /// Update app dialog
  Future<void> showUpdateDialog() async {
    await showGeneralDialog(
      context: Get.context!,
      barrierDismissible: false,
      useRootNavigator: true,
      barrierLabel: 'string',
      barrierColor: AppColors.TRANSPARENT,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.WHITE_COLOR,
          surfaceTintColor: AppColors.WHITE_COLOR,
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.WHITE_COLOR,
            ),
            height: context.isPortrait ? 35.h : 65.h,
            width: context.isPortrait ? 80.w : 40.w,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 5.w : 5.h, vertical: context.isPortrait ? 2.h : 2.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.updateAnim,
                  height: context.isPortrait ? 10.h : 10.w,
                ),
                SizedBox(height: context.isPortrait ? 2.h : 2.w),
                Text(
                  AppStrings.newVersionAvailable.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontSize: context.isPortrait ? 18.sp : 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Obx(() {
                  return ButtonWidget(
                    onPressed: () async {
                      await _downloadAndInstall();
                    },
                    isLoading: isUpdateLoading.value,
                    loaderWidget: Row(
                      children: [
                        Text(
                          "${downloadedProgress.value}%",
                          style: TextStyle(
                            color: AppColors.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontSize: context.isPortrait ? 14.sp : 12.sp,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: context.isPortrait ? 5.w : 5.h,
                                width: context.isPortrait ? 5.w : 5.h,
                                child: CircularProgressIndicator(
                                  color: AppColors.PRIMARY_COLOR,
                                  strokeWidth: 1.6,
                                  value: downloadedProgress.value / 100,
                                ),
                              ),
                              SizedBox(width: 4.w),
                            ],
                          ),
                        )
                      ],
                    ),
                    buttonTitle: AppStrings.update.tr,
                    buttonTitleColor: AppColors.PRIMARY_COLOR,
                    buttonColor: AppColors.SECONDARY_COLOR,
                  );
                }),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        );
      },
    );
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

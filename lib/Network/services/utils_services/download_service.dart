import 'dart:io';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloaderService extends GetxController {
  final RxDouble _progressValue = 0.0.obs;

  @override
  onInit() async {
    super.onInit();
    await Get.dialog(
      barrierColor: AppColors.TRANSPARENT,
      PopScope(
        canPop: false,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(() {
                return LinearProgressIndicator(
                  color: AppColors.TERTIARY_COLOR,
                  minHeight: 4,
                  value: _progressValue.value,
                  backgroundColor: AppColors.PRIMARY_COLOR.withValues(alpha: 0.25),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.TERTIARY_COLOR),
                );
              }),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<File?> fileDownloadService({
    required String url,
    required String fileName,
    bool showLoader = true,
  }) async {
    final response = await Dio().download(
      url,
      "/storage/emulated/0/Download/$fileName",
      onReceiveProgress: (count, total) {
        _progressValue.value = count * 100 / total;
      },
    );
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    if (showLoader) {
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        Utils.handleMessage(message: AppStrings.successfullyDownloadedAtDownloadFolder.tr);
      } else {
        Utils.handleMessage(message: AppStrings.downloadFailedPleaseTryAgain.tr, isError: true);
      }
    }
    final downloadedFile = File("/storage/emulated/0/Download/$fileName");
    return downloadedFile.existsSync() ? downloadedFile : null;
  }
}

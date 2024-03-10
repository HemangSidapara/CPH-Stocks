import 'dart:async';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialog extends GetxController with GetSingleTickerProviderStateMixin {
  static var isOpen = false;
  final RxDouble _progressValue = 0.0.obs;
  final RxBool _progressStart = true.obs;

  @override
  void onInit() {
    super.onInit();
    simulateSlowLoader();
  }

  Future<void> simulateSlowLoader() async {
    if (_progressStart.value) {
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 10));
        _progressValue.value = i / 100.0;
      }
      _progressStart(false);
    } else {
      _progressValue.value = 0.0;
      _progressStart(true);
    }
    simulateSlowLoader();
  }

  showProgressDialog(bool showDialog) {
    if (showDialog) {
      isOpen = true;
      if (kDebugMode) {
        print('|--------------->🕙️ Loader start 🕑️<---------------|');
      }

      Get.dialog(
        barrierColor: AppColors.TRANSPARENT,
        PopScope(
          canPop: false,
          onPopInvoked: (value) => Future.value(true),
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
                    backgroundColor: AppColors.PRIMARY_COLOR.withOpacity(0.25),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.TERTIARY_COLOR),
                  );
                }),
              ],
            ),
          ),
        ),
        barrierDismissible: false, /*useRootNavigator: false*/
      );
    } else if (Get.isDialogOpen == true) {
      if (kDebugMode) {
        print('|--------------->🕙️ Loader end 🕑️<---------------|');
      }
      Get.back();
      isOpen = false;
    }
  }
}

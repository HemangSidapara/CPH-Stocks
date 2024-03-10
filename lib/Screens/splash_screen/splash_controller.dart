import 'dart:async';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxBool isAlive = false.obs;
  RxString newAPKUrl = ''.obs;
  RxString newAPKVersion = ''.obs;
  RxString accessToken = ''.obs;
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

    Future.delayed(
      const Duration(seconds: 3),
      () async {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: AppColors.WHITE_COLOR,
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
      },
    );
  }
}

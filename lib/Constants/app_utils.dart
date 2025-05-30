import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Utils {
  ///Unfocus
  static void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Current app is latest or not
  static bool isUpdateAvailable(String currentVersion, String newAPKVersion) {
    List<String> versionNumberList = currentVersion.split('.').toList();
    List<String> storeVersionNumberList = newAPKVersion.split('.').toList();
    for (int i = 0; i < versionNumberList.length; i++) {
      if (versionNumberList[i].toInt() != storeVersionNumberList[i].toInt()) {
        if (versionNumberList[i].toInt() < storeVersionNumberList[i].toInt()) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  /// Sets the order data in the local storage.
  ///
  /// The method updates the existing order data with the provided [data].
  /// If no order data exists, it initializes the storage with the new [data].
  ///
  /// The [data] parameter is a map containing the order details that need to be
  /// stored or updated.
  ///
  /// Returns a [Future] that completes when the data is successfully stored.
  static Future<void> setOrderData({required Map<String, dynamic> data}) async {
    final listOrder = getList(AppConstance.setOrderData);
    if (listOrder.isEmpty) {
      listOrder.add(data);
    } else {
      listOrder[0] = data;
    }
    await setData(AppConstance.setOrderData, listOrder);
  }

  ///showSnackBar
  static void handleMessage({
    String? message,
    bool isError = false,
    bool isWarning = false,
    Color? barColor,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    if (!Get.isSnackbarOpen) {
      Get.rawSnackbar(
        margin: Get.context != null
            ? Get.context!.isPortrait
                ? EdgeInsets.only(bottom: 12.w + 1.h, left: 7.w, right: 7.w)
                : EdgeInsets.only(bottom: 12.h + 1.w, left: 20.w, right: 20.w)
            : EdgeInsets.only(bottom: 12.w + 1.h, left: 7.w, right: 7.w),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 3500),
        backgroundColor: barColor ??
            (isError
                ? AppColors.ERROR_COLOR
                : isWarning
                    ? AppColors.WARNING_COLOR
                    : AppColors.SUCCESS_COLOR),
        borderRadius: 12,
        padding: Get.context != null
            ? Get.context!.isPortrait
                ? EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h)
                : EdgeInsets.symmetric(horizontal: 3.h, vertical: 1.w)
            : EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        messageText: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    isError
                        ? Icons.error_rounded
                        : isWarning
                            ? Icons.warning_rounded
                            : Icons.check_circle_rounded,
                    color: iconColor ?? AppColors.WHITE_COLOR,
                  ),
                  SizedBox(
                      width: Get.context != null
                          ? Get.context!.isPortrait
                              ? 3.w
                              : 3.h
                          : 3.w),
                  Expanded(
                    child: Text(
                      message ?? 'Empty message',
                      style: TextStyle(
                        fontSize: Get.context != null
                            ? Get.context!.isPortrait
                                ? 15.sp
                                : 12.sp
                            : 15.sp,
                        color: textColor ?? AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null) ...[
              SizedBox(
                  width: Get.context != null
                      ? Get.context!.isPortrait
                          ? 2.w
                          : 2.h
                      : 2.w),
              InkWell(
                onTap: onTap,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.PRIMARY_COLOR,
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    child: Text(
                      AppStrings.open.tr,
                      style: AppStyles.size16w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }
}

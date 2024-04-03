import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> showUpdateDialog({
  required void Function() onUpdate,
  required RxBool isUpdateLoading,
  required RxInt downloadedProgress,
}) async {
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
          height: 35.h,
          width: 80.w,
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
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
                  onPressed: onUpdate,
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

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> showDeleteDialog({
  required BuildContext ctx,
  required void Function()? onPressed,
  required String title,
  IconData? iconData,
  Color? iconColor,
  String? agreeText,
}) async {
  await showGeneralDialog(
    context: ctx,
    barrierDismissible: true,
    barrierLabel: 'string',
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(animation),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
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
          width: 80.w,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              Icon(
                iconData ?? Icons.delete_forever_rounded,
                color: iconColor ?? AppColors.DARK_RED_COLOR,
                size: 8.w,
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.SECONDARY_COLOR,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Cancel
                    ButtonWidget(
                      onPressed: () {
                        Get.back();
                      },
                      fixedSize: Size(30.w, 5.h),
                      buttonTitle: AppStrings.cancel.tr,
                      buttonColor: AppColors.DARK_GREEN_COLOR,
                      buttonTitleColor: AppColors.PRIMARY_COLOR,
                    ),

                    ///Delete
                    ButtonWidget(
                      onPressed: onPressed,
                      fixedSize: Size(30.w, 5.h),
                      buttonTitle: agreeText ?? AppStrings.delete.tr,
                      buttonColor: AppColors.DARK_RED_COLOR,
                      buttonTitleColor: AppColors.PRIMARY_COLOR,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      );
    },
  );
}

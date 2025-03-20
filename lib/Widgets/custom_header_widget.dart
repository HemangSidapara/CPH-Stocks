import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String title;
  final String titleIcon;
  final double? titleIconSize;
  final void Function()? onBackPressed;
  final bool isCustomer;

  const CustomHeaderWidget({
    super.key,
    required this.title,
    required this.titleIcon,
    this.onBackPressed,
    this.titleIconSize,
    this.isCustomer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBackPressed != null) ...[
          IconButton(
            onPressed: onBackPressed,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR.withValues(alpha: 0.5),
              surfaceTintColor: AppColors.PRIMARY_COLOR,
              highlightColor: AppColors.PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Image.asset(
              AppAssets.backIcon,
              width: 8.w,
            ),
          ),
          SizedBox(width: 2.w),
        ],
        if (isCustomer) ...[
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.settingsScreen);
            },
            style: IconButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR.withValues(alpha: 0.5),
              surfaceTintColor: AppColors.PRIMARY_COLOR,
              highlightColor: AppColors.PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Image.asset(
              AppAssets.settingsIcon,
              width: 8.w,
            ),
          ),
          SizedBox(width: 2.w),
        ],
        Text(
          title,
          style: TextStyle(
            color: AppColors.PRIMARY_COLOR,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(width: 2.w),
        Image.asset(
          titleIcon,
          width: titleIconSize ?? 12.w,
        ),
      ],
    );
  }
}

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CloseButton(
      onPressed: () {
        Get.back();
      },
      style: IconButton.styleFrom(iconSize: 6.w),
      color: AppColors.TERTIARY_COLOR,
    );
  }
}

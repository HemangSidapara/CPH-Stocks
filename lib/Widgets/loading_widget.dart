import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoadingWidget extends StatelessWidget {
  final Color? loaderColor;
  const LoadingWidget({super.key, this.loaderColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: context.isPortrait ? 8.w : 6.h,
          width: context.isPortrait ? 8.w : 6.h,
          child: CircularProgressIndicator(
            color: loaderColor ?? AppColors.PRIMARY_COLOR,
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }
}

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoDataFoundWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String subtitle;
  final double? bottomMargin;
  final double? imageSize;

  const NoDataFoundWidget({super.key, this.onPressed, required this.subtitle, this.bottomMargin, this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(AppAssets.noDataFoundAnim, height: imageSize ?? 20.h),
        SizedBox(height: 3.h),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: Text(subtitle, style: AppStyles.size16w600.copyWith(color: AppColors.PRIMARY_COLOR)),
        ),
        SizedBox(height: bottomMargin ?? 15.h),
      ],
    );
  }
}

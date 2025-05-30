import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
          height: context.isPortrait ? 40.w : 30.h,
          width: context.isPortrait ? 40.w : 30.h,
          child: Lottie.asset(
            AppAssets.customLoaderAnim,
          ),
        ),
      ],
    );
  }
}

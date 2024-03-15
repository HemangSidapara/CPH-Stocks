import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final String buttonTitle;
  final Size? fixedSize;
  final OutlinedBorder? shape;
  final bool isLoading;
  final Color? buttonColor;

  const ButtonWidget({
    super.key,
    this.onPressed,
    this.child,
    this.buttonTitle = '',
    this.fixedSize,
    this.shape,
    this.isLoading = false,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        surfaceTintColor: AppColors.PRIMARY_COLOR,
        fixedSize: Size(double.maxFinite, 5.h),
      ),
      child: isLoading
          ? SizedBox(
              height: 5.w,
              width: 5.w,
              child: CircularProgressIndicator(
                color: AppColors.WHITE_COLOR,
                strokeWidth: 1.6,
              ),
            )
          : child ??
              Text(
                buttonTitle,
                style: TextStyle(
                  color: AppColors.SECONDARY_COLOR,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
    );
  }
}

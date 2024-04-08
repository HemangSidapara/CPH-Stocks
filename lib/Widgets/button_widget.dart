import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final String buttonTitle;
  final Color? buttonTitleColor;
  final Size? fixedSize;
  final OutlinedBorder? shape;
  final bool isLoading;
  final Color? buttonColor;
  final Widget? loaderWidget;
  final Color? loaderColor;

  const ButtonWidget({
    super.key,
    this.onPressed,
    this.child,
    this.buttonTitle = '',
    this.fixedSize,
    this.shape,
    this.isLoading = false,
    this.buttonColor,
    this.buttonTitleColor,
    this.loaderWidget,
    this.loaderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? AppColors.PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        surfaceTintColor: AppColors.PRIMARY_COLOR,
        fixedSize: fixedSize ?? Size(double.maxFinite, 5.h),
      ),
      child: isLoading
          ? loaderWidget ??
              SizedBox(
                height: 5.w,
                width: 5.w,
                child: CircularProgressIndicator(
                  color: loaderColor ?? AppColors.SECONDARY_COLOR,
                  strokeWidth: 1.6,
                ),
              )
          : child ??
              Text(
                buttonTitle,
                style: TextStyle(
                  color: buttonTitleColor ?? AppColors.SECONDARY_COLOR,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
    );
  }
}

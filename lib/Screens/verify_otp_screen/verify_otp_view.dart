import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/verify_otp_screen/verify_otp_controller.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return UnfocusWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100.w, 10.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.8.h),
            child: Center(
              child: Text(
                AppStrings.verifyOtp.tr,
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        bottomSheet: Material(
          color: AppColors.SECONDARY_COLOR,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: keyboardPadding != 0 ? 2.h : 5.h),
            child: Obx(() {
              return ButtonWidget(
                onPressed: () async {
                  Utils.unfocus();
                  await controller.checkVerifyOtp();
                },
                buttonTitle: AppStrings.verify.tr,
                isLoading: controller.isVerifyLoading.value,
              );
            }),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h).copyWith(bottom: keyboardPadding != 0 ? 10.h : 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///OTP Image
                Image.asset(
                  AppAssets.otpImage,
                  height: 20.h,
                ),
                SizedBox(height: 5.h),

                ///OTP
                Form(
                  key: controller.verifyFormKey,
                  child: Pinput(
                    controller: controller.otpController,
                    validator: controller.otpValidator,
                    length: 6,
                    onCompleted: (value) {
                      controller.checkVerifyOtp();
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    cursor: SizedBox(
                      height: 2.h,
                      width: 0.4.w,
                      child: ColoredBox(
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 15.w,
                      height: 15.w,
                      margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                      decoration: BoxDecoration(
                        color: AppColors.SECONDARY_COLOR,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.PRIMARY_COLOR,
                            width: 1.2,
                          ),
                        ),
                      ),
                      textStyle: AppStyles.size16w600,
                    ),
                    defaultPinTheme: PinTheme(
                      width: 15.w,
                      height: 15.w,
                      margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                      decoration: BoxDecoration(
                        color: AppColors.SECONDARY_COLOR,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.MAIN_BORDER_COLOR,
                            width: 1.2,
                          ),
                        ),
                      ),
                      textStyle: AppStyles.size16w600,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                ///Resend Otp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Timer
                    Obx(() {
                      return AnimatedOpacity(
                        opacity: controller.resendTimer.value != "00:00" ? 1 : 0,
                        duration: 375.milliseconds,
                        child: Text(
                          controller.resendTimer.value,
                          style: AppStyles.size16w600.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      );
                    }),

                    /// Resend otp
                    Obx(() {
                      return TextButton(
                        onPressed: controller.resendTimer.value != "00:00" || controller.isResendLoading.isTrue
                            ? null
                            : () async {
                                controller.isResendLoading(true);
                                controller.timer?.cancel();
                                await controller.sendOtp();
                                controller.resendTimer("00:30");
                                controller.setTimer();
                                controller.isResendLoading(false);
                              },
                        child: controller.isResendLoading.isTrue
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: CircularProgressIndicator(
                                  color: AppColors.PRIMARY_COLOR,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppStrings.resendOtp.tr,
                                style: AppStyles.size16w600.copyWith(
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.PRIMARY_COLOR,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

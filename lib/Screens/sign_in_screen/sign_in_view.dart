import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/sign_in_screen/sign_in_controller.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return GestureDetector(
      onTap: () => Utils.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100.w, 10.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.8.h),
            child: Center(
              child: Text(
                AppStrings.login.tr,
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
                  await controller.checkSignIn();
                },
                buttonTitle: AppStrings.login.tr,
                isLoading: controller.isSignInLoading.value,
              );
            }),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h).copyWith(bottom: keyboardPadding != 0 ? 10.h : 0),
          child: Form(
            key: controller.signInFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///Login Image
                  Image.asset(
                    AppAssets.loginImage,
                    height: 20.h,
                  ),
                  SizedBox(height: 5.h),

                  ///Phone number
                  TextFieldWidget(
                    controller: controller.phoneController,
                    title: AppStrings.phoneNumber.tr,
                    hintText: AppStrings.enterPhoneNumber.tr,
                    validator: controller.phoneValidator,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    maxLength: 10,
                  ),
                  SizedBox(height: 2.h),

                  ///Password
                  Obx(() {
                    return TextFieldWidget(
                      controller: controller.passwordController,
                      title: AppStrings.password.tr,
                      hintText: AppStrings.enterPassword.tr,
                      obscureText: controller.isPasswordVisible.isFalse,
                      validator: controller.passwordValidator,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.isPasswordVisible.toggle();
                        },
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          controller.isPasswordVisible.isTrue ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          color: controller.isPasswordVisible.isTrue ? AppColors.SECONDARY_COLOR : AppColors.HINT_GREY_COLOR,
                          size: 5.5.w,
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(minWidth: 12.w),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

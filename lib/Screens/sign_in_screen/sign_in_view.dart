import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Screens/sign_in_screen/sign_in_controller.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Form(
          key: controller.signInFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                AppAssets.loginImage,
                height: 20.h,
              ),
              SizedBox(height: 5.h),

              ///Username
              TextFieldWidget(
                controller: controller.userNameController,
                title: AppStrings.userName.tr,
                hintText: AppStrings.enterUserName.tr,
                validator: controller.userNameValidator,
              ),
              SizedBox(height: 2.h),

              ///Password
              TextFieldWidget(
                controller: controller.passwordController,
                title: AppStrings.password.tr,
                hintText: AppStrings.enterPassword.tr,
                obscureText: controller.isPasswordVisible.isFalse,
                validator: controller.passwordValidator,
              ),
              const Spacer(),

              ///Login Button
              ElevatedButton(
                onPressed: () async {
                  await controller.checkSignIn();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  surfaceTintColor: AppColors.PRIMARY_COLOR,
                  fixedSize: Size(double.maxFinite, 5.h),
                ),
                child: Text(
                  AppStrings.login.tr,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

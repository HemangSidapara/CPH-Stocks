import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Network/services/auth_services/auth_services.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  RxBool isSignInLoading = false.obs;

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPhoneNumber.tr;
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPassword.tr;
    }
    return null;
  }

  Future<void> checkSignIn() async {
    try {
      isSignInLoading(true);
      final isValid = signInFormKey.currentState?.validate();

      if (isValid == true) {
        final response = await AuthServices.loginService(
          phone: phoneController.text,
          password: passwordController.text,
        );

        if (response.isSuccess) {
          if (response.response?.data['role'] == null) {
            return;
          } else if (response.response?.data['role'] == AppConstance.admin || response.response?.data['role'] == AppConstance.employee) {
            Get.offAllNamed(Routes.homeScreen);
          } else {
            Get.offAllNamed(Routes.orderDetailsScreen);
          }
        }
      }
    } finally {
      isSignInLoading(false);
    }
  }
}

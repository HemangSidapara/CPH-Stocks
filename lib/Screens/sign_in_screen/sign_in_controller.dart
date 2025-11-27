import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/auth_models/login_model.dart';
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
          LoginModel loginModel = LoginModel.fromJson(response.response?.data ?? {});
          if (loginModel.role == null) {
            return;
          } else {
            if ([AppConstance.admin].contains(loginModel.role)) {
              await clearData();
              loginModel = loginModel.copyWith(phone: phoneController.text);
              Get.toNamed(
                Routes.verifyOtpScreen,
                arguments: loginModel.toJson(),
              );
            } else {
              Utils.handleMessage(message: response.response?.data['msg']);
              Get.offAllNamed(Routes.homeScreen);
            }
          }
        }
      }
    } finally {
      isSignInLoading(false);
    }
  }
}

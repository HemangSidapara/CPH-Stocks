import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  String? userNameValidator(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterUserName.tr;
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
    final isValid = signInFormKey.currentState?.validate();

    if (isValid == true) {
      Get.offAllNamed(Routes.homeScreen);
    }
  }
}

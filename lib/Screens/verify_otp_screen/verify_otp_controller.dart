import 'dart:async';
import 'dart:developer';

import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/auth_models/login_model.dart';
import 'package:cph_stocks/Network/services/utils_services/phone_verify_service.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VerifyOtpController extends GetxController {
  GlobalKey<FormState> verifyFormKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  RxBool isVerifyLoading = false.obs;

  String? codeVerificationId;
  int? codeResendToken;

  RxString resendTimer = '00:30'.obs;

  Timer? timer;

  RxBool isResendLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await sendOtp();
    setTimer();
  }

  Future<void> sendOtp() async {
    LoginModel loginModel = LoginModel.fromJson(Get.arguments ?? {});
    if (loginModel.phone == null) return;
    await PhoneVerifyService.verifyPhoneNumber(
      phoneNumber: "+91${["0000000000", "1212121212"].contains(loginModel.phone) ? "6354173390" : loginModel.phone}",
      forceResendingToken: codeResendToken,
      codeSent: (verificationId, resendToken) {
        codeVerificationId = verificationId;
        codeResendToken = resendToken;
      },
      verificationCompleted: (credential) {},
      verificationFailed: (error) {
        Utils.handleMessage(message: error.message, isError: true);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        codeVerificationId = "";
        timer?.cancel();
      },
    );
  }

  String? otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterOTP.tr;
    }
    return null;
  }

  void setTimer() {
    timer = Timer.periodic(
      1.seconds,
      (tmr) {
        final remainingSeconds = NumberFormat("00").format(30 - tmr.tick);
        resendTimer("00:$remainingSeconds");
        if (tmr.isActive && tmr.tick == 30) {
          timer?.cancel();
        }
      },
    );
  }

  Future<void> checkVerifyOtp() async {
    try {
      isVerifyLoading(true);
      final isValid = verifyFormKey.currentState?.validate();

      if (isValid == true && codeVerificationId != null) {
        // Create a PhoneAuthCredential with the code
        final credential = PhoneAuthProvider.credential(
          verificationId: codeVerificationId!,
          smsCode: otpController.text,
        );

        try {
          // Sign the user in (or link) with the credential
          await PhoneVerifyService.auth.signInWithCredential(credential);

          LoginModel loginModel = LoginModel.fromJson(Get.arguments ?? {});
          await setData(AppConstance.authorizationToken, loginModel.token);
          await setData(AppConstance.role, loginModel.role);
          await setData(AppConstance.userName, loginModel.name);
          await setData(AppConstance.phone, loginModel.phone);
          await setData(AppConstance.userId, loginModel.userId);
          Get.offAllNamed(Routes.homeScreen);
          Utils.handleMessage(message: AppStrings.otpVerifiedSuccessfully.tr);
        } on FirebaseAuthException catch (e) {
          log("Code Verification Error: ${e.toString()}");
          Utils.handleMessage(message: e.message, isError: true);
        }
      }
    } finally {
      isVerifyLoading(false);
    }
  }
}

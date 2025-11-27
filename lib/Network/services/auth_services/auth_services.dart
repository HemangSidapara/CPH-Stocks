import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/models/auth_models/get_latest_version_model.dart';
import 'package:cph_stocks/Network/models/auth_models/get_user_details_model.dart';
import 'package:cph_stocks/Network/models/auth_models/login_model.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:cph_stocks/Network/services/utils_services/firebase_service.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthServices {
  static Future<ResponseModel> getLatestVersionService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.inAppUpdateApi,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) async {
        if (res.isSuccess) {
          GetLatestVersionModel latestVersionModel = GetLatestVersionModel.fromJson(res.response?.data);
          if (kDebugMode) {
            print("inAppUpdateApi success :: ${latestVersionModel.msg}");
          }
        } else {
          if (kDebugMode) {
            print("inAppUpdateApi error :: ${res.message}");
          }
        }
      },
    );

    return response;
  }

  static Future<ResponseModel> loginService({
    required String phone,
    required String password,
  }) async {
    final fcmToken = await FirebaseService.getFcmToken();
    final params = {
      ApiKeys.phone: phone,
      ApiKeys.password: password,
      ApiKeys.fcmToken: fcmToken,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.loginApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) async {
        if (res.isSuccess) {
          LoginModel loginModel = LoginModel.fromJson(res.response?.data ?? {});
          await setData(AppConstance.authorizationToken, loginModel.token);
          await setData(AppConstance.role, loginModel.role);
          await setData(AppConstance.userName, loginModel.name);
          await setData(AppConstance.phone, phone);
          await setData(AppConstance.userId, loginModel.userId);
          if (kDebugMode) {
            print("loginApi success :: ${loginModel.msg}");
          }
        } else {
          if (kDebugMode) {
            print("loginApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }

  static Future<ResponseModel> checkTokenService() async {
    final fcmToken = await FirebaseService.getFcmToken();
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.checkTokenApi + (fcmToken ?? ""),
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      showProgress: false,
      onSuccess: (res) async {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("checkTokenApi success :: ${res.message}");
          }
          GetUserDetailsModel userDetailsModel = GetUserDetailsModel.fromJson(res.response?.data ?? {});
          await setData(AppConstance.role, userDetailsModel.role);
          await setData(AppConstance.userName, userDetailsModel.name);
          await setData(AppConstance.userId, userDetailsModel.userId);
          if (kDebugMode) {
            print("checkTokenApi success :: ${userDetailsModel.code}");
          }
        } else if (res.statusCode == 498) {
          if (kDebugMode) {
            print("checkTokenApi error :: ${res.message}");
          }
          Get.offAllNamed(Routes.signInScreen);
          Utils.handleMessage(message: AppStrings.sessionExpire.tr, isError: true);
          clearData();
        } else {
          if (kDebugMode) {
            print("checkTokenApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }

  static Future<ResponseModel> downloadBackupService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.downloadBackupApi,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      showProgress: false,
      onSuccess: (res) async {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("downloadBackupApi success :: ${res.message}");
          }
        } else if (res.statusCode == 498) {
          if (kDebugMode) {
            print("downloadBackupApi error :: ${res.message}");
          }
          Get.offAllNamed(Routes.signInScreen);
          Utils.handleMessage(message: AppStrings.sessionExpire.tr, isError: true);
          clearData();
        } else {
          if (kDebugMode) {
            print("checkTokenApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }
}

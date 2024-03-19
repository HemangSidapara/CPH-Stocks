import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/models/auth_models/login_model.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/material.dart';

class AuthServices {
  static Future<ResponseModel> loginService({
    required String phone,
    required String password,
  }) async {
    final params = {
      ApiKeys.phone: phone,
      ApiKeys.password: password,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.loginApi,
      params: params,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) async {
        if (res.isSuccess) {
          LoginModel loginModel = LoginModel.fromJson(res.response?.data);
          await setData(AppConstance.authorizationToken, loginModel.token);
          await setData(AppConstance.role, loginModel.role);
          debugPrint("loginApi success :: ${loginModel.msg}");
          Utils.handleMessage(message: loginModel.msg);
        } else {
          debugPrint("loginApi error :: ${res.message}");
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }
}

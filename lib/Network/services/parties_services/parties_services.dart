import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/foundation.dart';

class PartiesServices {
  static Future<ResponseModel> getPartyService({String search = ""}) async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getPartyApi + search,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getPartyApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getPartyApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  static Future<ResponseModel> createPartyService({
    required String partyName,
    required String contactNumber,
    required String paymentType,
    required String pendingBalance,
  }) async {
    final params = {
      ApiKeys.partyName: partyName,
      ApiKeys.contactNumber: contactNumber,
      ApiKeys.paymentType: paymentType,
      ApiKeys.pendingBalance: pendingBalance,
    };

    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.createPartyApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("createPartyApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("createPartyApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  static Future<ResponseModel> editPartyService({
    required String orderId,
    required String partyName,
    required String contactNumber,
    required String paymentType,
    required String pendingBalance,
  }) async {
    final params = {
      ApiKeys.orderId: orderId,
      ApiKeys.partyName: partyName,
      ApiKeys.contactNumber: contactNumber,
      ApiKeys.paymentType: paymentType,
      ApiKeys.pendingBalance: pendingBalance,
    };

    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.editPartyApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("editPartyApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("editPartyApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

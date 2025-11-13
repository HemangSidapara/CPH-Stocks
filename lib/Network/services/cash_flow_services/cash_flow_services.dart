import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CashFlowServices {
  /// Get Cash Flow Service
  static Future<ResponseModel> getCashFlowService({
    required String startDate,
    required String endDate,
    required String transactionType,
  }) async {
    final response = await ApiBaseHelper.getHTTP(
      "${ApiUrls.getCashFlowApi}&startDate=$startDate&endDate=$endDate&transactionType=$transactionType",
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      showProgress: false,
      onSuccess: (res) async {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getCashFlowApi success :: ${res.message}");
          }
        } else if (res.statusCode == 498) {
          if (kDebugMode) {
            print("getCashFlowApi error :: ${res.message}");
          }
          Get.offAllNamed(Routes.signInScreen);
          Utils.handleMessage(message: AppStrings.sessionExpire.tr, isError: true);
          clearData();
        } else {
          if (kDebugMode) {
            print("getCashFlowApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }

  /// Add Cash Flow Service
  static Future<ResponseModel> addCashFlowService({
    required String cashType,
    required String note,
    required String modeOfPayment,
    required String amount,
    required String createdDate,
  }) async {
    final params = {
      ApiKeys.cashType: cashType,
      ApiKeys.note: note,
      ApiKeys.modeOfPayment: modeOfPayment,
      ApiKeys.amount: amount,
      ApiKeys.createdDate: createdDate,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.addCashFlowApi,
      params: params,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      showProgress: false,
      onSuccess: (res) async {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("addCashFlowApi success :: ${res.message}");
          }
        } else if (res.statusCode == 498) {
          if (kDebugMode) {
            print("addCashFlowApi error :: ${res.message}");
          }
          Get.offAllNamed(Routes.signInScreen);
          Utils.handleMessage(message: AppStrings.sessionExpire.tr, isError: true);
          clearData();
        } else {
          if (kDebugMode) {
            print("addCashFlowApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }

  /// Edit Cash Flow Service
  static Future<ResponseModel> editCashFlowService({
    required String cashFlowId,
    required String cashType,
    required String note,
    required String modeOfPayment,
    required String amount,
    required String createdDate,
  }) async {
    final params = {
      ApiKeys.cashFlowId: cashFlowId,
      ApiKeys.cashType: cashType,
      ApiKeys.note: note,
      ApiKeys.modeOfPayment: modeOfPayment,
      ApiKeys.amount: amount,
      ApiKeys.createdDate: createdDate,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.editCashFlowApi,
      params: params,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      showProgress: false,
      onSuccess: (res) async {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("editCashFlowApi success :: ${res.message}");
          }
        } else if (res.statusCode == 498) {
          if (kDebugMode) {
            print("editCashFlowApi error :: ${res.message}");
          }
          Get.offAllNamed(Routes.signInScreen);
          Utils.handleMessage(message: AppStrings.sessionExpire.tr, isError: true);
          clearData();
        } else {
          if (kDebugMode) {
            print("editCashFlowApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }

  /// Delete Cash Flow Service
  static Future<ResponseModel> deleteCashFlowService({
    required String cashFlowId,
  }) async {
    final response = await ApiBaseHelper.deleteHTTP(
      "${ApiUrls.deleteCashFlowApi}&cashFlowId=$cashFlowId",
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      showProgress: false,
      onSuccess: (res) async {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("deleteCashFlowApi success :: ${res.message}");
          }
        } else if (res.statusCode == 498) {
          if (kDebugMode) {
            print("deleteCashFlowApi error :: ${res.message}");
          }
          Get.offAllNamed(Routes.signInScreen);
          Utils.handleMessage(message: AppStrings.sessionExpire.tr, isError: true);
          clearData();
        } else {
          if (kDebugMode) {
            print("deleteCashFlowApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }

  /// Accept/Reject Delete Cash Flow Service
  static Future<ResponseModel> acceptRejectDeleteCashFlowService({
    required String cashFlowId,
    required bool isAccept,
  }) async {
    final response = await ApiBaseHelper.deleteHTTP(
      "${ApiUrls.acceptRejectDeleteCashFlowApi}&cashFlowId=$cashFlowId&isAccept=$isAccept",
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      showProgress: false,
      onSuccess: (res) async {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("acceptRejectDeleteCashFlowApi success :: ${res.message}");
          }
        } else if (res.statusCode == 498) {
          if (kDebugMode) {
            print("acceptRejectDeleteCashFlowApi error :: ${res.message}");
          }
          Get.offAllNamed(Routes.signInScreen);
          Utils.handleMessage(message: AppStrings.sessionExpire.tr, isError: true);
          clearData();
        } else {
          if (kDebugMode) {
            print("acceptRejectDeleteCashFlowApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );

    return response;
  }
}

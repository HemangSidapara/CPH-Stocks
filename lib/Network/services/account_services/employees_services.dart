import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/foundation.dart';

class EmployeesServices {
  /// Get No Of Employees Service
  static Future<ResponseModel> getNoOfEmployeesService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getNoOfEmployeesApi,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getNoOfEmployeesApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getNoOfEmployeesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getNoOfEmployeesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Add No Of Employees Service
  static Future<ResponseModel> addNoOfEmployeesService({
    required String month,
    required String year,
    required String noOfEmployees,
  }) async {
    final params = {
      ApiKeys.month: month,
      ApiKeys.year: year,
      ApiKeys.noOfEmployees: noOfEmployees,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.addNoOfEmployeesApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("addNoOfEmployeesApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("addNoOfEmployeesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("addNoOfEmployeesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Edit No Of Employees Service
  static Future<ResponseModel> editNoOfEmployeesService({
    required String totalEmployeeId,
    required String noOfEmployees,
  }) async {
    final params = {
      ApiKeys.totalEmployeeId: totalEmployeeId,
      ApiKeys.noOfEmployees: noOfEmployees,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.editNoOfEmployeesApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("editNoOfEmployeesApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("editNoOfEmployeesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("addNoOfEmployeesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Reports Service
  static Future<ResponseModel> getReportsService({
    required String startDate,
    required String endDate,
  }) async {
    final params = {
      ApiKeys.startDate: startDate,
      ApiKeys.endDate: endDate,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.getReportApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getReportApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getReportApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getReportApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

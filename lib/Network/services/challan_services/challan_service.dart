import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/foundation.dart';

class ChallanService {
  /// Get Invoices
  static Future<ResponseModel> getInvoicesService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getInvoicesApi,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getInvoicesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getInvoicesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Generate Invoice
  static Future<ResponseModel> generateInvoiceService({
    required List<String> orderMetaIds,
  }) async {
    final params = {
      ApiKeys.orderMetaIds: orderMetaIds,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.generateInvoiceApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("generateInvoiceApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("generateInvoiceApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Delete Invoices
  static Future<ResponseModel> deleteInvoicesService({
    required List<String> orderInvoiceIds,
  }) async {
    final params = {
      ApiKeys.orderInvoiceIds: orderInvoiceIds,
    };
    final response = await ApiBaseHelper.deleteHTTP(
      ApiUrls.deleteInvoicesApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("deleteInvoicesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("deleteInvoicesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Delete Invoices
  static Future<ResponseModel> editInvoiceService({
    required String invoiceMetaId,
    required String categoryId,
    required String inch,
  }) async {
    final params = {
      ApiKeys.invoiceMetaId: invoiceMetaId,
      ApiKeys.categoryId: categoryId,
      ApiKeys.inch: inch,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.editInvoiceApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("editInvoiceApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("editInvoiceApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

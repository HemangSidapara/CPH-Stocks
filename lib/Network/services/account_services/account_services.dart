import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/foundation.dart';

class AccountServices {
  /// Generate Ledger Invoice
  static Future<ResponseModel> generateLedgerInvoiceService({
    required String startDate,
    required String endDate,
    required String partyId,
  }) async {
    final params = {
      ApiKeys.startDate: startDate,
      ApiKeys.endDate: endDate,
      ApiKeys.partyId: partyId,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.getLedgerInvoicesApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getLedgerInvoicesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getLedgerInvoicesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Generate Payment Ledger Invoice
  static Future<ResponseModel> generatePaymentLedgerInvoiceService({
    required String startDate,
    required String endDate,
    required String partyId,
  }) async {
    final params = {
      ApiKeys.startDate: startDate,
      ApiKeys.endDate: endDate,
      ApiKeys.partyId: partyId,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.getPaymentLedgerInvoicesApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getPaymentLedgerInvoicesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getPaymentLedgerInvoicesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

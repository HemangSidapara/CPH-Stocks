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
        if (kDebugMode) {
          print("getPaymentLedgerInvoicesApi onError :: ${dioExceptions.message}");
        }
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

  /// Get Party Payment Service
  static Future<ResponseModel> getPartyPaymentService({
    required String partyId,
  }) async {
    final params = {
      ApiKeys.partyId: partyId,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.getPartyPaymentApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getPartyPaymentApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getPartyPaymentApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getPartyPaymentApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Create Party Payment Service
  static Future<ResponseModel> createPartyPaymentService({
    required String partyId,
    required String amount,
    required String paymentMode,
  }) async {
    final params = {
      ApiKeys.partyId: partyId,
      ApiKeys.amount: amount,
      ApiKeys.paymentMode: paymentMode,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.createPartyPaymentApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("createPartyPaymentApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("createPartyPaymentApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("createPartyPaymentApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Edit Party Payment Service
  static Future<ResponseModel> editPartyPaymentService({
    required String partyPaymentMetaId,
    required String amount,
    required String paymentMode,
  }) async {
    final params = {
      ApiKeys.partyPaymentMetaId: partyPaymentMetaId,
      ApiKeys.amount: amount,
      ApiKeys.paymentMode: paymentMode,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.editPartyPaymentApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("editPartyPaymentApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("editPartyPaymentApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("editPartyPaymentApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Delete Party Payment Service
  static Future<ResponseModel> deletePartyPaymentService({
    required String partyPaymentMetaId,
  }) async {
    final params = {
      ApiKeys.partyPaymentMetaId: partyPaymentMetaId,
    };
    final response = await ApiBaseHelper.deleteHTTP(
      ApiUrls.deletePartyPaymentApi,
      params: params,
      showProgress: true,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("deletePartyPaymentApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("deletePartyPaymentApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("deletePartyPaymentApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Automatic Ledger Payment Service
  static Future<ResponseModel> getAutomaticLedgerPaymentService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getAutomaticLedgerPaymentApi,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getAutomaticLedgerPaymentApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getAutomaticLedgerPaymentApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getAutomaticLedgerPaymentApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Automatic Ledger Invoice Service
  static Future<ResponseModel> getAutomaticLedgerInvoiceService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getAutomaticLedgerInvoiceApi,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getAutomaticLedgerInvoiceApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getAutomaticLedgerInvoiceApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getAutomaticLedgerPaymentApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Ledger Payment Service
  static Future<ResponseModel> getLedgerPaymentService({
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
      ApiUrls.getLedgerPaymentApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getLedgerPaymentApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getLedgerPaymentApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getLedgerPaymentApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Pending Payments Service
  static Future<ResponseModel> getPendingPaymentsService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getPendingPaymentsApi,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getPendingPaymentsApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getPendingPaymentsApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getPendingPaymentsApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

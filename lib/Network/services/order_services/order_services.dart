import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/foundation.dart';

class OrderServices {
  /// Get Parties
  static Future<ResponseModel> getPartiesService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getPartiesApi,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getPartiesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getPartiesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Create Order
  static Future<ResponseModel> createOrderService({
    required String partyName,
    required String contactNumber,
    required List<Map<String, dynamic>> meta,
    required String description,
    required bool isGst,
    String? partyId,
  }) async {
    final params = {
      ApiKeys.partyId: partyId,
      ApiKeys.partyName: partyName,
      ApiKeys.contactNumber: contactNumber,
      ApiKeys.isGst: isGst,
      ApiKeys.description: description,
      ApiKeys.meta: meta,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.createOrderApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("createOrderApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("createOrderApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Orders
  static Future<ResponseModel> getOrdersService({bool isRecycleBin = false, bool isRepair = false}) async {
    final response = await ApiBaseHelper.getHTTP(
      isRepair ? ApiUrls.getRepairOrdersApi : "${ApiUrls.getOrdersApi}${isRecycleBin ? "1" : "0"}",
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("${isRepair ? "getRepairOrdersApi" : "getOrdersApi"} Exception :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("${isRepair ? "getRepairOrdersApi" : "getOrdersApi"} success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("${isRepair ? "getRepairOrdersApi" : "getOrdersApi"} error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Create Order Cycle
  static Future<ResponseModel> createOrderCycleService({
    required String orderMetaId,
    required String okPcs,
    required String woProcess,
    required String repair,
  }) async {
    final params = {
      ApiKeys.orderMetaId: orderMetaId,
      ApiKeys.okPcs: okPcs,
      ApiKeys.woProcess: woProcess,
      ApiKeys.repair: repair,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.createOrderCycleApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("createOrderCycleApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("createOrderCycleApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Order Cycles
  static Future<ResponseModel> getOrderCyclesService({
    required String orderMetaId,
  }) async {
    final params = {
      ApiKeys.orderMetaId: orderMetaId,
    };
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getOrderCyclesApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getOrderCyclesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getOrderCyclesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Delete Order Cycles
  static Future<ResponseModel> deleteOrderCycleService({
    required String orderCycleId,
  }) async {
    final params = {
      ApiKeys.orderCycleId: orderCycleId,
    };
    final response = await ApiBaseHelper.deleteHTTP(
      ApiUrls.deleteOrderCycleApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("deleteOrderCycleApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("deleteOrderCycleApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Update Party
  static Future<ResponseModel> updatePartyService({
    required String orderId,
    required String partyName,
    required String contactNumber,
    required bool isGst,
  }) async {
    final params = {
      ApiKeys.orderId: orderId,
      ApiKeys.partyName: partyName,
      ApiKeys.contactNumber: contactNumber,
      ApiKeys.isGst: isGst,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.updatePartyApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("updatePartyApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("updatePartyApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Delete Party
  static Future<ResponseModel> deletePartyService({
    required String orderId,
  }) async {
    final params = {
      ApiKeys.orderId: orderId,
    };
    final response = await ApiBaseHelper.deleteHTTP(
      ApiUrls.deletePartyApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("deletePartyApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("deletePartyApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Update Item
  static Future<ResponseModel> updateItemService({
    required String orderMetaId,
    required String itemName,
    required String categoryName,
    required String itemImage,
    required String pvdColor,
    required String quantity,
    required String size,
  }) async {
    final params = {
      ApiKeys.orderMetaId: orderMetaId,
      ApiKeys.itemName: itemName,
      ApiKeys.categoryName: categoryName,
      ApiKeys.pvdColor: pvdColor,
      ApiKeys.quantity: quantity,
      ApiKeys.size: size,
      ApiKeys.itemImage: itemImage,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.updateOrderApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("updateOrderApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("updateOrderApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Delete Order
  static Future<ResponseModel> deleteOrderService({
    required List<String> orderMetaId,
  }) async {
    final params = {
      ApiKeys.orderMetaId: orderMetaId,
    };
    final response = await ApiBaseHelper.deleteHTTP(
      ApiUrls.deleteOrderApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("deleteOrderApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("deleteOrderApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Last Billed Cycle
  static Future<ResponseModel> lastBilledCycleService({
    required String orderCycleId,
    required String challanNumber,
    required bool flag,
  }) async {
    final params = {
      ApiKeys.orderCycleId: orderCycleId,
      ApiKeys.challanNumber: challanNumber,
      ApiKeys.flag: flag.toString(),
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.lastBilledCycleApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("lastBilledCycleApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("lastBilledCycleApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Is Dispatched
  static Future<ResponseModel> isDispatchedCycleService({
    required String orderCycleId,
    required bool flag,
  }) async {
    final params = {
      ApiKeys.orderCycleId: orderCycleId,
      ApiKeys.flag: flag.toString(),
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.isDispatchedApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("isDispatchedApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("isDispatchedApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Orders Meta
  static Future<ResponseModel> getOrdersMetaService({
    required String createdDate,
    required String createdTime,
    required String pvdColor,
  }) async {
    final params = {
      ApiKeys.createdDate: createdDate,
      ApiKeys.createdTime: createdTime,
      ApiKeys.pvdColor: pvdColor,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.getOrdersMetaApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getOrdersMetaApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getOrdersMetaApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Multiple Last Billed Cycle
  static Future<ResponseModel> multipleLastBilledCycleService({
    required List<String> orderCycleId,
    required String challanNumber,
    required bool flag,
  }) async {
    final params = {
      ApiKeys.orderCycleId: orderCycleId,
      ApiKeys.challanNumber: challanNumber,
      ApiKeys.flag: flag.toString(),
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.multipleLastBilledCycleApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("multipleLastBilledCycleApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("multipleLastBilledCycleApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Categories
  static Future<ResponseModel> getCategoriesService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getCategoriesApi,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getCategoriesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getCategoriesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Order Sequence
  static Future<ResponseModel> getOrderSequenceService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getOrderSequenceApi,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getOrderSequenceApi Exception :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getOrderSequenceApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getOrderSequenceApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

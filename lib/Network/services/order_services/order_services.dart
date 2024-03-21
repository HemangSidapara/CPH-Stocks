import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/material.dart';

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
          debugPrint("getPartiesApi success :: ${res.message}");
        } else {
          debugPrint("getPartiesApi error :: ${res.message}");
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Create Order
  static Future<ResponseModel> createOrderService({
    required String partyName,
    required String itemName,
    required String pvdColor,
    required String quantity,
    required String size,
    required String itemImage,
  }) async {
    final params = {
      ApiKeys.partyName: partyName,
      ApiKeys.meta: [
        {
          ApiKeys.itemName: itemName,
          ApiKeys.pvdColor: pvdColor,
          ApiKeys.quantity: quantity,
          ApiKeys.size: size,
          // ApiKeys.itemImage: '',
          ApiKeys.itemImage: itemImage,
        },
      ],
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
          debugPrint("createOrderApi success :: ${res.message}");
        } else {
          debugPrint("createOrderApi error :: ${res.message}");
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Get Orders
  static Future<ResponseModel> getOrdersService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getOrdersApi,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          debugPrint("getOrdersApi success :: ${res.message}");
        } else {
          debugPrint("getOrdersApi error :: ${res.message}");
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
  }) async {
    final params = {
      ApiKeys.orderMetaId: orderMetaId,
      ApiKeys.okPcs: okPcs,
      ApiKeys.woProcess: woProcess,
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
          debugPrint("createOrderCycleApi success :: ${res.message}");
        } else {
          debugPrint("createOrderCycleApi error :: ${res.message}");
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
          debugPrint("getOrderCyclesApi success :: ${res.message}");
        } else {
          debugPrint("getOrderCyclesApi error :: ${res.message}");
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

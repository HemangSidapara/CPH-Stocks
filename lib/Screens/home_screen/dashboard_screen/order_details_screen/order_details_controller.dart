import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/get_orders_model.dart' as get_orders;
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<get_orders.Data> searchedOrderList = RxList();
  RxList<get_orders.Data> orderList = RxList();
  RxBool isGetOrdersLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  GlobalKey<FormState> editPartyFormKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();
    await getOrdersApi();
  }

  String? validatePartyName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPartyName.tr;
    }
    return null;
  }

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterContactNumber.tr;
    }
    return null;
  }

  Future<void> getOrdersApi({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetOrdersLoading(isLoading);
      final response = await OrderServices.getOrdersService();

      if (response.isSuccess) {
        get_orders.GetOrdersModel ordersModel = get_orders.GetOrdersModel.fromJson(response.response?.data);
        orderList.clear();
        searchedOrderList.clear();
        orderList.addAll(ordersModel.data ?? []);
        searchedOrderList.addAll(ordersModel.data ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetOrdersLoading(false);
    }
  }

  Future<void> updatePartyApi({
    required String orderId,
    required String partyName,
    required String contactNumber,
  }) async {
    final isValidate = editPartyFormKey.currentState?.validate();

    if (isValidate == true) {
      final response = await OrderServices.updatePartyService(
        orderId: orderId,
        partyName: partyName,
        contactNumber: contactNumber,
      );

      if (response.isSuccess) {
        Get.back();
        await getOrdersApi(isLoading: false).then((value) => Utils.handleMessage(message: response.message));
      }
    }
  }

  Future<void> deletePartyApi({
    required String orderId,
  }) async {
    final response = await OrderServices.deletePartyService(
      orderId: orderId,
    );

    if (response.isSuccess) {
      Get.back();
      await getOrdersApi(isLoading: false).then((value) => Utils.handleMessage(message: response.message));
    }
  }

  Future<void> deleteOrderApi({
    required String orderMetaId,
  }) async {
    final response = await OrderServices.deleteOrderService(
      orderMetaId: orderMetaId,
    );

    if (response.isSuccess) {
      Get.back();
      await getOrdersApi(isLoading: false).then((value) => Utils.handleMessage(message: response.message));
    }
  }

  Future<void> searchPartyName(String searchedValue) async {
    searchedOrderList.clear();
    if (searchedValue.isNotEmpty) {
      searchedOrderList.addAll(orderList.where((element) => element.partyName?.toLowerCase().contains(searchedValue.toLowerCase()) == true));
    } else {
      searchedOrderList.addAll(orderList);
    }
  }
}

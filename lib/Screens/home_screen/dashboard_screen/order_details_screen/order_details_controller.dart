import 'package:cph_stocks/Network/models/order_models/get_orders_model.dart' as get_orders;
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  TextEditingController searchController = TextEditingController();
  RxList<get_orders.Data> searchedOrderList = RxList();
  RxList<get_orders.Data> orderList = RxList();
  RxBool isGetOrdersLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getOrdersApi();
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

  Future<void> searchPartyName(String searchedValue) async {
    searchedOrderList.clear();
    if (searchedValue.isNotEmpty) {
      searchedOrderList.addAll(orderList.where((element) => element.partyName?.toLowerCase().contains(searchedValue.toLowerCase()) == true));
    } else {
      searchedOrderList.addAll(orderList);
    }
  }
}

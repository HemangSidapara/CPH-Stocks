import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/get_order_cycles_model.dart' as get_order_cycles;
import 'package:cph_stocks/Network/models/order_models/item_id_model.dart';
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:get/get.dart';

class ViewCyclesController extends GetxController {
  ItemDetailsModel arguments = ItemDetailsModel();

  RxBool isGetOrderCycleLoading = false.obs;
  RxBool isDeletingOrderCycleLoading = false.obs;
  RxBool isBilledOrderCycleLoading = false.obs;

  RxString challanUrl = ''.obs;
  RxString contactNumber = ''.obs;
  RxList<get_order_cycles.Data> orderCycleList = RxList();

  @override
  void onInit() async {
    super.onInit();
    arguments = Get.arguments;
    await getOrderCyclesApi();
  }

  Future<void> getOrderCyclesApi({bool isLoading = true}) async {
    try {
      isGetOrderCycleLoading(isLoading);
      final response = await OrderServices.getOrderCyclesService(orderMetaId: arguments.itemId ?? '');

      if (response.isSuccess) {
        get_order_cycles.GetOrderCyclesModel getOrderCyclesModel = get_order_cycles.GetOrderCyclesModel.fromJson(response.response?.data);
        challanUrl.value = getOrderCyclesModel.invoice ?? '';
        contactNumber.value = getOrderCyclesModel.contactNumber ?? '';
        orderCycleList.clear();
        orderCycleList.addAll(getOrderCyclesModel.data ?? []);
      }
    } finally {
      isGetOrderCycleLoading(false);
    }
  }

  Future<void> deleteCycleApi({required String orderCycleId}) async {
    try {
      isDeletingOrderCycleLoading(true);
      final response = await OrderServices.deleteOrderCycleService(orderCycleId: orderCycleId);

      if (response.isSuccess) {
        await getOrderCyclesApi().then((value) {
          Get.back();
          Future.delayed(
            const Duration(milliseconds: 300),
            () {
              Utils.handleMessage(message: response.message);
            },
          );
          Get.find<OrderDetailsController>().getOrdersApi(isLoading: false);
        });
      }
    } finally {
      isDeletingOrderCycleLoading(false);
    }
  }

  Future<void> lastBilledCycleApi({
    required String orderCycleId,
    required String challanNumber,
    required bool flag,
    Function(String message)? onSuccess,
  }) async {
    try {
      isBilledOrderCycleLoading(true);
      final response = await OrderServices.lastBilledCycleService(
        orderCycleId: orderCycleId,
        challanNumber: challanNumber,
        flag: flag,
      );

      if (response.isSuccess) {
        await getOrderCyclesApi(isLoading: false);
        onSuccess?.call(response.message);
      }
    } finally {
      isBilledOrderCycleLoading(false);
    }
  }

  Future<void> isDispatchedCycleApi({
    required String orderCycleId,
    required bool flag,
  }) async {
    final response = await OrderServices.isDispatchedCycleService(
      orderCycleId: orderCycleId,
      flag: flag,
    );

    if (response.isSuccess) {
      await getOrderCyclesApi(isLoading: false);
    }
  }
}

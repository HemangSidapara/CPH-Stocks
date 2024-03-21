import 'package:cph_stocks/Network/models/order_models/get_order_cycles_model.dart' as get_order_cycles;
import 'package:cph_stocks/Network/models/order_models/item_id_model.dart';
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:get/get.dart';

class ViewCyclesController extends GetxController {
  ItemIdModel arguments = ItemIdModel();

  RxBool isGetOrderCycleLoading = false.obs;

  RxList<get_order_cycles.Data> orderCycleList = RxList();

  @override
  void onInit() async {
    super.onInit();
    arguments = Get.arguments;
    await getOrderCyclesApi();
  }

  Future<void> getOrderCyclesApi() async {
    try {
      isGetOrderCycleLoading(true);
      final response = await OrderServices.getOrderCyclesService(orderMetaId: arguments.itemId ?? '');

      if (response.isSuccess) {
        get_order_cycles.GetOrderCyclesModel getOrderCyclesModel = get_order_cycles.GetOrderCyclesModel.fromJson(response.response?.data);
        orderCycleList.clear();
        orderCycleList.addAll(getOrderCyclesModel.data ?? []);
      }
    } finally {
      isGetOrderCycleLoading(false);
    }
  }
}

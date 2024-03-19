import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/add_order_cycle_screen/add_order_cycle_controller.dart';
import 'package:get/get.dart';

class AddOrderCycleBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddOrderCycleController());
  }
}

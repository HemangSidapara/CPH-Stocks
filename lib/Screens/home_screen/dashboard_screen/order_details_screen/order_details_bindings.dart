import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:get/get.dart';

class OrderDetailsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(OrderDetailsController());
  }
}

import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/view_cycles_screen/view_cycles_controller.dart';
import 'package:get/get.dart';

class ViewCyclesBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ViewCyclesController());
  }
}

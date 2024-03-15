import 'package:cph_stocks/Screens/home_screen/dashboard_screen/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}

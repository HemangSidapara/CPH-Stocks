import 'package:cph_stocks/Screens/home_screen/dashboard_screen/repairing_details_screen/repairing_details_controller.dart';
import 'package:get/get.dart';

class RepairingDetailsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RepairingDetailsController());
  }
}

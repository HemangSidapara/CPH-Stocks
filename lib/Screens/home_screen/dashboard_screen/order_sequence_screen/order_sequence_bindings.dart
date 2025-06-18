import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_sequence_screen/order_sequence_controller.dart';
import 'package:get/get.dart';

class OrderSequenceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderSequenceController());
  }
}

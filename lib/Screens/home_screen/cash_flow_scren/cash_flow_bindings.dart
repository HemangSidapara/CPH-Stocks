import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_controller.dart';
import 'package:get/get.dart';

class CashFlowBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(CashFlowController());
  }
}

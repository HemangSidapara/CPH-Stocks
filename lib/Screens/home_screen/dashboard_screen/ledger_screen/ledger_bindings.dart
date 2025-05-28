import 'package:cph_stocks/Screens/home_screen/dashboard_screen/ledger_screen/ledger_controller.dart';
import 'package:get/get.dart';

class LedgerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LedgerController());
  }
}

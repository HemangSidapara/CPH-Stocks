import 'package:cph_stocks/Screens/home_screen/account_screen/pending_payment_screen/pending_payment_controller.dart';
import 'package:get/get.dart';

class PendingPaymentBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PendingPaymentController());
  }
}

import 'package:cph_stocks/Screens/home_screen/account_screen/payment_details_screen/payment_details_controller.dart';
import 'package:get/get.dart';

class PaymentDetailsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentDetailsController());
  }
}

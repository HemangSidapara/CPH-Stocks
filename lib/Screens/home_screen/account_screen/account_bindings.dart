import 'package:cph_stocks/Screens/home_screen/account_screen/account_controller.dart';
import 'package:get/get.dart';

class AccountBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }
}

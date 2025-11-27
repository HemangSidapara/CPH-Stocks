import 'package:cph_stocks/Screens/verify_otp_screen/verify_otp_controller.dart';
import 'package:get/get.dart';

class VerifyOtpBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(VerifyOtpController());
  }
}

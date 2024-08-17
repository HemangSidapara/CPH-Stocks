import 'package:cph_stocks/Screens/home_screen/recycle_bin_screen/recycle_bin_controller.dart';
import 'package:get/get.dart';

class RecycleBinBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(RecycleBinController());
  }
}

import 'package:cph_stocks/Screens/home_screen/parties_screen/parties_controller.dart';
import 'package:get/get.dart';

class PartiesBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PartiesController());
  }
}

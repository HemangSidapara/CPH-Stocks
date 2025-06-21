import 'package:get/get.dart';

import 'reports_controller.dart';

class ReportsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportsController());
  }
}

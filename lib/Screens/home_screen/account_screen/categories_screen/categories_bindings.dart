import 'package:cph_stocks/Screens/home_screen/account_screen/categories_screen/categories_controller.dart';
import 'package:get/get.dart';

class CategoriesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoriesController());
  }
}

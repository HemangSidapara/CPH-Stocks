import 'package:cph_stocks/Screens/home_screen/account_screen/employees_in_month_screen/employees_in_month_controller.dart';
import 'package:get/get.dart';

class EmployeesInMonthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeesInMonthController());
  }
}

import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/employee_models/no_of_employees_model.dart' as get_employees;
import 'package:cph_stocks/Network/services/account_services/employees_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeesInMonthController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt tabIndex = 0.obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> monthList = [
    AppStrings.january,
    AppStrings.february,
    AppStrings.march,
    AppStrings.april,
    AppStrings.may,
    AppStrings.june,
    AppStrings.july,
    AppStrings.august,
    AppStrings.september,
    AppStrings.october,
    AppStrings.november,
    AppStrings.december,
  ];
  TextEditingController monthController = TextEditingController();
  RxInt selectedMonth = (-1).obs;
  List<String> yearList = List.generate(DateTime.now().year - 2022, (index) => "${DateTime.now().year - index}");
  RxInt selectedYear = 0.obs;
  TextEditingController yearController = TextEditingController(text: DateTime.now().year.toString());
  TextEditingController noOfEmployeesController = TextEditingController();

  RxList<get_employees.EmployeeRecord> employeesList = RxList();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNoOfEmployeesApiCall();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex(tabController.index);
    });
  }

  String? validateMonth(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseSelectMonth.tr;
    }
    return null;
  }

  String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseSelectYear.tr;
    }
    return null;
  }

  String? validateNoOfEmployees(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterNoOfEmployees.tr;
    }
    return null;
  }

  Future<void> getNoOfEmployeesApiCall({bool isRefresh = false}) async {
    try {
      isLoading(!isRefresh);
      final response = await EmployeesServices.getNoOfEmployeesService();
      if (response.isSuccess) {
        get_employees.NoOfEmployeesModel noOfEmployeesModel = get_employees.NoOfEmployeesModel.fromJson(response.response?.data);
        employeesList.clear();
        employeesList.addAll(noOfEmployeesModel.data ?? []);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addNoOfEmployeesApiCall() async {
    try {
      isLoading(true);
      if (formKey.currentState?.validate() ?? false) {
        final response = await EmployeesServices.addNoOfEmployeesService(
          month: (selectedMonth.value + 1).toString(),
          year: yearList[selectedYear.value],
          noOfEmployees: noOfEmployeesController.text.trim(),
        );

        if (response.isSuccess) {
          await getNoOfEmployeesApiCall();
          Utils.handleMessage(message: response.message);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> editNoOfEmployeesApiCall({
    required String totalEmployeeId,
    required String noOfEmployees,
  }) async {
    final response = await EmployeesServices.editNoOfEmployeesService(
      totalEmployeeId: totalEmployeeId,
      noOfEmployees: noOfEmployees,
    );

    if (response.isSuccess) {
      Get.back();
      await getNoOfEmployeesApiCall();
      Utils.handleMessage(message: response.message);
    }
  }
}

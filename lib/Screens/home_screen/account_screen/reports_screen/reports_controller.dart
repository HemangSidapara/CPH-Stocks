import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Network/models/employee_models/get_reports_model.dart' as get_reports;
import 'package:cph_stocks/Network/services/account_services/employees_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportsController extends GetxController with GetSingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController startDateController = TextEditingController(
    text: DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(const Duration(days: 7))),
  );
  TextEditingController endDateController = TextEditingController(
    text: DateFormat("yyyy-MM-dd").format(DateTime.now()),
  );

  RxBool isGeneratingReport = false.obs;
  RxBool isLoading = false.obs;

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  RxList<get_reports.InchWiseReport> inchReportList = RxList();
  RxList<get_reports.AmountWiseReport> amountReportList = RxList();
  RxList<get_reports.NoOfEmployeeReport> noOfEmployeeReportList = RxList();

  @override
  void onInit() {
    super.onInit();
    getReportsApiCall();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex(tabController.index);
    });
  }

  String? validateStartDate(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectStartDate.tr;
    }
    return null;
  }

  String? validateEndDate(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectEndDate.tr;
    }
    return null;
  }

  Future<void> getReportsApiCall({bool isRefresh = false}) async {
    try {
      isLoading(!isRefresh);
      if (formKey.currentState?.validate() ?? true) {
        final response = await EmployeesServices.getReportsService(
          startDate: startDateController.text,
          endDate: endDateController.text,
        );
        if (response.isSuccess) {
          get_reports.GetReportsModel reportsModel = get_reports.GetReportsModel.fromJson(response.response?.data);
          inchReportList.clear();
          amountReportList.clear();
          inchReportList.addAll(reportsModel.inchWiseReport ?? []);
          amountReportList.addAll(reportsModel.amountWiseReport ?? []);
          noOfEmployeeReportList.addAll(reportsModel.noOfEmployeeReport ?? []);
        }
      }
    } finally {
      isLoading(false);
    }
  }
}

import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/cash_flow_models/get_cash_flow_model.dart' as get_cash_flow;
import 'package:cph_stocks/Network/response_model.dart';
import 'package:cph_stocks/Network/services/cash_flow_services/cash_flow_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashFlowController extends GetxController with GetTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  TextEditingController searchCashFlowController = TextEditingController();

  RxList<get_cash_flow.CashFlowData> cashCashFlowList = RxList();
  RxList<get_cash_flow.CashFlowData> onlineCashFlowList = RxList();
  RxList<get_cash_flow.CashFlowData> searchCashCashFlowList = RxList();
  RxList<get_cash_flow.CashFlowData> searchOnlineCashFlowList = RxList();

  Rx<get_cash_flow.Summary> summeryData = Rx(get_cash_flow.Summary());

  Rx<DateTimeRange<DateTime>?> filterDateRange = Rx(DateTimeRange<DateTime>(start: DateTime.now().subtract(7.days), end: DateTime.now()));

  RxString deletingId = "".obs;
  RxString acceptDeletingId = "".obs;
  RxString rejectDeletingId = "".obs;

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  List<String> tabTypes = [
    AppStrings.cash,
    AppStrings.online,
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex(tabController.index);
    });
    getCashFlowApiCall();
  }

  Future<void> getCashFlowApiCall({bool isRefresh = false}) async {
    try {
      isLoading(!isRefresh);
      final response = await CashFlowServices.getCashFlowService(
        startDate: filterDateRange.value?.start.toLocal().toString().split(" ").first ?? "",
        endDate: filterDateRange.value?.end.toLocal().toString().split(" ").first ?? "",
      );
      if (response.isSuccess) {
        get_cash_flow.GetCashFlowModel cashFlowModel = get_cash_flow.GetCashFlowModel.fromJson(response.response?.data ?? {});

        summeryData.value = cashFlowModel.summary ?? summeryData.value;

        cashCashFlowList.clear();
        onlineCashFlowList.clear();
        searchCashCashFlowList.clear();
        searchOnlineCashFlowList.clear();
        cashCashFlowList.addAll(cashFlowModel.data?.where((element) => element.modeOfPayment == AppStrings.cash).toList() ?? []);
        searchCashCashFlowList.addAll([...cashCashFlowList]);
        onlineCashFlowList.addAll(cashFlowModel.data?.where((element) => element.modeOfPayment != AppStrings.cash).toList() ?? []);
        searchOnlineCashFlowList.addAll([...onlineCashFlowList]);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCashFlowApiCall({required String cashFlowId}) async {
    try {
      deletingId(cashFlowId);
      final response = await CashFlowServices.deleteCashFlowService(
        cashFlowId: cashFlowId,
      );
      if (response.isSuccess) {
        await getCashFlowApiCall();
        Utils.handleMessage(message: response.message);
      }
    } finally {
      deletingId("");
    }
  }

  Future<ResponseModel> addCashFlowApiCall({
    required String cashType,
    required String note,
    required String modeOfPayment,
    required String amount,
  }) async {
    final response = await CashFlowServices.addCashFlowService(
      note: note,
      cashType: cashType,
      amount: amount,
      modeOfPayment: modeOfPayment,
    );
    return response;
  }

  Future<ResponseModel> editCashFlowApiCall({
    required String cashFlowId,
    required String cashType,
    required String note,
    required String modeOfPayment,
    required String amount,
  }) async {
    final response = await CashFlowServices.editCashFlowService(
      cashFlowId: cashFlowId,
      note: note,
      cashType: cashType,
      amount: amount,
      modeOfPayment: modeOfPayment,
    );
    return response;
  }

  Future<void> acceptRejectDeleteCashFlowApiCall({
    required String cashFlowId,
    required bool isAccept,
  }) async {
    try {
      acceptDeletingId(isAccept ? cashFlowId : "");
      rejectDeletingId(!isAccept ? cashFlowId : "");
      final response = await CashFlowServices.acceptRejectDeleteCashFlowService(
        cashFlowId: cashFlowId,
        isAccept: isAccept,
      );
      if (response.isSuccess) {
        await getCashFlowApiCall();
        Utils.handleMessage(message: response.message);
      }
    } finally {
      acceptDeletingId("");
      rejectDeletingId("");
    }
  }
}

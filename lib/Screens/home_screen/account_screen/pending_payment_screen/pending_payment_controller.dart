import 'package:cph_stocks/Network/models/account_models/get_pending_payments_model.dart' as get_pending_payments;
import 'package:cph_stocks/Network/services/account_services/account_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingPaymentController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchPartyNameController = TextEditingController();

  RxList<get_pending_payments.PendingParty> pendingPaymentList = RxList();
  RxList<get_pending_payments.PendingParty> searchPendingPaymentList = RxList();

  RxDouble totalPendingAmount = 0.0.obs;

  Rx<DateTimeRange<DateTime>?> filterDateRange = Rx(null);

  @override
  void onInit() {
    super.onInit();
    getPendingPaymentApiCall();
  }

  Future<void> getPendingPaymentApiCall({bool isRefresh = false}) async {
    try {
      isLoading(!isRefresh);
      final response = await AccountServices.getPendingPaymentsService(
        startDate: filterDateRange.value?.start.toLocal().toIso8601String(),
        endDate: filterDateRange.value?.start.toLocal().toIso8601String(),
      );

      if (response.isSuccess) {
        get_pending_payments.GetPendingPaymentsModel pendingPaymentModel = get_pending_payments.GetPendingPaymentsModel.fromJson(response.response?.data);
        totalPendingAmount.value = pendingPaymentModel.totalPendingAmount ?? 0.0;
        pendingPaymentList.clear();
        searchPendingPaymentList.clear();
        pendingPaymentList.addAll(pendingPaymentModel.data ?? []);
        searchPendingPaymentList.addAll(pendingPaymentModel.data ?? []);
      }
    } finally {
      isLoading(false);
    }
  }

  void searchParty(String value) {
    searchPendingPaymentList.clear();
    if (value.isNotEmpty) {
      searchPendingPaymentList.addAll(pendingPaymentList.where((element) => element.partyName?.toLowerCase().contains(value.toLowerCase()) == true).toList());
    } else {
      searchPendingPaymentList.addAll([...pendingPaymentList]);
    }
    final amounts = searchPendingPaymentList.map((element) => element.pendingAmount ?? 0.0).toList();
    totalPendingAmount.value = amounts.isNotEmpty ? amounts.reduce((value, element) => value + element) : 0.0;
  }
}

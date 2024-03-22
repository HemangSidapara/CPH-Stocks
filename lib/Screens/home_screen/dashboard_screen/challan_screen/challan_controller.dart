import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart' as get_invoices;
import 'package:cph_stocks/Network/services/challan_services/challan_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallanController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<get_invoices.Data> searchedInvoiceList = RxList();
  RxList<get_invoices.Data> invoiceList = RxList();
  RxBool isGetInvoicesLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getInvoicesApi();
  }

  Future<void> getInvoicesApi({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetInvoicesLoading(isLoading);
      final response = await ChallanService.getInvoicesService();

      if (response.isSuccess) {
        get_invoices.GetInvoicesModel invoicesModel = get_invoices.GetInvoicesModel.fromJson(response.response?.data);
        invoiceList.clear();
        searchedInvoiceList.clear();
        invoiceList.addAll(invoicesModel.data ?? []);
        searchedInvoiceList.addAll(invoicesModel.data ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetInvoicesLoading(false);
    }
  }

  Future<void> searchPartyName(String searchedValue) async {
    searchedInvoiceList.clear();
    if (searchedValue.isNotEmpty) {
      searchedInvoiceList.addAll(invoiceList.where((element) => element.partyName?.toLowerCase().contains(searchedValue.toLowerCase()) == true));
    } else {
      searchedInvoiceList.addAll(invoiceList);
    }
  }
}

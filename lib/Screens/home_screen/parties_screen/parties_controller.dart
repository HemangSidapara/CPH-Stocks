import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/parties_models/get_party_model.dart' as get_party;
import 'package:cph_stocks/Network/services/parties_services/parties_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PartiesController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();

  RxList<get_party.PartyData> partyList = <get_party.PartyData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getPartyApiCall();
  }

  Future<void> getPartyApiCall({bool isRefresh = false}) async {
    try {
      isLoading(!isRefresh);
      final response = await PartiesServices.getPartyService(search: searchController.text);
      if (response.isSuccess) {
        get_party.GetPartyModel partyModel = get_party.GetPartyModel.fromJson(response.response?.data ?? {});
        partyList.clear();
        partyList.addAll(partyModel.data ?? []);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> createPartyApiCall({
    required String partyName,
    required String contactNumber,
    required String paymentType,
    required String pendingBalance,
  }) async {
    isLoading(true);
    final response = await PartiesServices.createPartyService(
      partyName: partyName,
      contactNumber: contactNumber,
      paymentType: paymentType,
      pendingBalance: pendingBalance,
    );
    if (response.isSuccess) {
      await getPartyApiCall();
      Get.back();
      Utils.handleMessage(message: response.message);
    }
  }

  Future<void> editPartyApiCall({
    required String orderId,
    required String partyName,
    required String contactNumber,
    required String paymentType,
    required String pendingBalance,
  }) async {
    final response = await PartiesServices.editPartyService(
      orderId: orderId,
      partyName: partyName,
      contactNumber: contactNumber,
      paymentType: paymentType,
      pendingBalance: pendingBalance,
    );
    if (response.isSuccess) {
      await getPartyApiCall();
      Get.back();
      Utils.handleMessage(message: response.message);
    }
  }
}

import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LedgerController extends GetxController {
  GlobalKey<FormState> ledgerFormKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();

  RxBool isGenerateLoading = false.obs;

  RxList<get_parties.Data> partyList = <get_parties.Data>[].obs;
  RxString selectedParty = "".obs;

  @override
  void onInit() {
    super.onInit();
    getPartiesApi();
  }

  String? validatePartyName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectParty.tr;
    }
    return null;
  }

  Future<RxList<get_parties.Data>> getPartiesApi() async {
    final response = await OrderServices.getPartiesService();
    if (response.isSuccess) {
      get_parties.GetPartiesModel getPartiesModel = get_parties.GetPartiesModel.fromJson(response.response?.data);
      partyList.clear();
      partyList.addAll(getPartiesModel.data ?? []);
    }
    return partyList;
  }
}

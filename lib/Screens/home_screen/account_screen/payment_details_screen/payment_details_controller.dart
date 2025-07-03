import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/app_validators.dart';
import 'package:cph_stocks/Network/models/account_models/get_party_payment_model.dart' as get_payments;
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/account_services/account_services.dart';
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentDetailsController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<get_parties.Data> partyList = <get_parties.Data>[].obs;
  RxString selectedParty = "".obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();
  RxInt selectedPaymentMode = 0.obs;

  RxList<get_payments.PartyPaymentData> paymentList = RxList();
  RxList<get_payments.PartyPaymentData> filteredPaymentList = RxList();

  RxBool isPaymentAddEnable = false.obs;
  RxBool isPaymentAdding = false.obs;

  List<String> paymentModeList = [
    AppStrings.cash,
    AppStrings.online,
    AppStrings.onlinePatel,
    AppStrings.onlineKevin,
    AppStrings.billGST,
  ];

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

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterAmount.tr;
    } else if (!AppValidators.doubleValidator.hasMatch(value)) {
      return AppStrings.pleaseEnterValidaAmount.tr;
    }
    return null;
  }

  String? validatePaymentMode(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectPaymentMode.tr;
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

  Future<void> getPartyPaymentApiCall({
    bool isRefresh = false,
  }) async {
    try {
      isLoading(!isRefresh);
      if (formKey.currentState?.validate() ?? false) {
        final response = await AccountServices.getPartyPaymentService(partyId: selectedParty.value);

        if (response.isSuccess) {
          get_payments.GetPartyPaymentModel partyPaymentModel = get_payments.GetPartyPaymentModel.fromJson(response.response?.data);
          paymentList.clear();
          filteredPaymentList.clear();
          paymentList.addAll(partyPaymentModel.data ?? []);
          filteredPaymentList.addAll(partyPaymentModel.data ?? []);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deletePaymentApiCall({String? partyPaymentMetaId}) async {
    final response = await AccountServices.deletePartyPaymentService(
      partyPaymentMetaId: partyPaymentMetaId ?? "",
    );

    if (response.isSuccess) {
      Utils.handleMessage(message: response.message);
      getPartyPaymentApiCall(isRefresh: true);
    }
  }

  Future<void> createPaymentApiCall() async {
    try {
      isPaymentAdding(true);
      if (formKey.currentState?.validate() ?? false) {
        final response = await AccountServices.createPartyPaymentService(
          partyId: selectedParty.value,
          amount: amountController.text.trim(),
          paymentMode: paymentModeList[selectedPaymentMode.value],
        );

        if (response.isSuccess) {
          await getPartyPaymentApiCall(isRefresh: filteredPaymentList.isNotEmpty);
          Utils.handleMessage(message: response.message);
        }
      }
    } finally {
      isPaymentAdding(false);
    }
  }

  Future<void> editPaymentApiCall({
    required String partyPaymentMetaId,
    required String amount,
    required String paymentMode,
  }) async {
    final response = await AccountServices.editPartyPaymentService(
      partyPaymentMetaId: partyPaymentMetaId,
      amount: amount,
      paymentMode: paymentMode,
    );

    if (response.isSuccess) {
      Get.back();
      await getPartyPaymentApiCall(isRefresh: true);
      Utils.handleMessage(message: response.message);
    }
  }
}

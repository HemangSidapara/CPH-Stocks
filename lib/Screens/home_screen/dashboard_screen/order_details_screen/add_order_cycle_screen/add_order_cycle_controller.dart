import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Network/models/order_models/pending_data_model.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddOrderCycleController extends GetxController {
  PendingDataModel arguments = PendingDataModel();

  GlobalKey<FormState> addOrderCycleFormKey = GlobalKey<FormState>();

  RxBool isAddOrderCycleLoading = false.obs;

  TextEditingController pendingController = TextEditingController();
  TextEditingController okPcsController = TextEditingController();
  TextEditingController woProcessController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;
    pendingController.text = arguments.pending?.toString() ?? '';
  }

  String? validatePending(String? value) {
    print(value);
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPending.tr;
    } else if (value.toInt() < 0) {
      return AppStrings.invalidInputs.tr;
    }
    return null;
  }

  String? validateOkPcs(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterOkPcs.tr;
    }
    return null;
  }

  String? validateWOProcess(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterWOProcess.tr;
    }
    return null;
  }

  Future<void> addOrderCycleApi() async {
    try {
      isAddOrderCycleLoading(true);
    } finally {
      isAddOrderCycleLoading(false);
    }
  }
}

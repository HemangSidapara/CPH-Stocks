import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
  GlobalKey<FormState> createOrderFormKey = GlobalKey<FormState>();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController pvdColorController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController okPcsController = TextEditingController();
  TextEditingController rejectedController = TextEditingController();
  TextEditingController pendingController = TextEditingController();

  RxBool isCreateOrderLoading = false.obs;

  String? validateItemName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterItemName.tr;
    }
    return null;
  }

  String? validatePVDColor(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPVDColor.tr;
    }
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterQuantity.tr;
    }
    return null;
  }

  String? validateSize(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterSize.tr;
    }
    return null;
  }

  String? validateOkPcs(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterOkPcs.tr;
    }
    return null;
  }

  String? validateRejected(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterRejected.tr;
    }
    return null;
  }

  String? validatePending(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPending.tr;
    }
    return null;
  }

  Future<void> createOrderApi() async {
    try {
      isCreateOrderLoading(true);
      final isValid = createOrderFormKey.currentState?.validate();

      if (isValid == true) {}
    } finally {
      isCreateOrderLoading(false);
    }
  }
}

import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
  GlobalKey<FormState> createOrderFormKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController pvdColorController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  RxString base64Image = ''.obs;

  RxBool isGetPartiesLoading = true.obs;
  RxList<get_parties.Data> partyList = RxList();
  RxInt selectedParty = (-1).obs;
  RxBool isCreateOrderLoading = false.obs;
  RxBool isImageSelected = false.obs;

  String? validatePartyName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPartyName.tr;
    }
    return null;
  }

  String? validatePartyList(get_parties.Data? value) {
    if (value == null && partyNameController.text.isEmpty) {
      return AppStrings.pleaseSelectParty.tr;
    }
    return null;
  }

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

  Future<RxList<get_parties.Data>> getPartiesApi() async {
    try {
      isGetPartiesLoading(true);
      final response = await OrderServices.getPartiesService();
      if (response.isSuccess) {
        get_parties.GetPartiesModel getPartiesModel = get_parties.GetPartiesModel.fromJson(response.response?.data);
        partyList.clear();
        partyList.addAll(getPartiesModel.data ?? []);
      }
      return partyList;
    } finally {
      isGetPartiesLoading(false);
    }
  }

  Future<void> createOrderApi() async {
    try {
      isCreateOrderLoading(true);
      final isValidate = createOrderFormKey.currentState?.validate();

      if (isValidate == true) {
        if (isImageSelected.value) {
          final response = await OrderServices.createOrderService(
            partyName: partyNameController.text.trim(),
            itemName: itemNameController.text.trim(),
            pvdColor: pvdColorController.text.trim(),
            quantity: quantityController.text.trim(),
            size: sizeController.text.trim(),
            itemImage: base64Image.value,
          );

          if (response.isSuccess) {
            Get.back();
            Utils.handleMessage(message: response.message);
          }
        } else {
          Utils.handleMessage(message: AppStrings.pleaseAddItemImage.tr, isError: true);
        }
      }
    } finally {
      isCreateOrderLoading(false);
    }
  }
}

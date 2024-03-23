import 'package:cph_stocks/Constants/api_keys.dart';
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
  TextEditingController contactNumberController = TextEditingController();
  RxList<TextEditingController> itemNameControllerList = RxList<TextEditingController>();
  RxList<TextEditingController> pvdColorControllerList = RxList<TextEditingController>();
  RxList<TextEditingController> quantityControllerList = RxList<TextEditingController>();
  RxList<TextEditingController> sizeControllerList = RxList<TextEditingController>();
  RxList<String> base64ImageList = RxList();

  RxList<String> pvdColorList = RxList([
    "Gold",
    "Rosegold",
    "Black",
    "Grey",
    "Bronze",
    "Rainbow",
  ]);
  RxList<int> selectedPvdColorList = RxList();

  RxBool isGetPartiesLoading = true.obs;
  RxList<get_parties.Data> partyList = RxList();
  RxInt selectedParty = (-1).obs;
  RxBool isCreateOrderLoading = false.obs;
  RxList<bool> isImageSelectedList = RxList();

  @override
  void onInit() {
    super.onInit();
    itemNameControllerList.add(TextEditingController());
    pvdColorControllerList.add(TextEditingController());
    quantityControllerList.add(TextEditingController());
    sizeControllerList.add(TextEditingController());
    base64ImageList.add('');
    isImageSelectedList.add(false);
    selectedPvdColorList.add(-1);
  }

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

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterContactNumber.tr;
    }
    return null;
  }

  String? validateItemName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterItemName.tr;
    }
    return null;
  }

  String? validatePvdColorList(String? value, int index) {
    if (value == null && pvdColorControllerList[index].text.isEmpty) {
      return AppStrings.pleaseSelectPvdColor.tr;
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
        if (isImageSelectedList.every((element) => element == true)) {
          List<Map<String, dynamic>> tempMetaList = [];
          for (int i = 0; i < itemNameControllerList.length; i++) {
            tempMetaList.add({
              ApiKeys.itemName: itemNameControllerList[i].text,
              ApiKeys.pvdColor: pvdColorControllerList[i].text,
              ApiKeys.quantity: quantityControllerList[i].text,
              ApiKeys.size: sizeControllerList[i].text,
              ApiKeys.itemImage: base64ImageList[i],
            });
          }
          final response = await OrderServices.createOrderService(
            partyName: partyNameController.text.trim(),
            contactNumber: contactNumberController.text.trim(),
            meta: tempMetaList,
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

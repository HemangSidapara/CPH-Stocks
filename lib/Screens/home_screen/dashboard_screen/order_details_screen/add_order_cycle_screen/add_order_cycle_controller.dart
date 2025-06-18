import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/item_id_model.dart';
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddOrderCycleController extends GetxController {
  ItemDetailsModel arguments = ItemDetailsModel();

  GlobalKey<FormState> addOrderCycleFormKey = GlobalKey<FormState>();

  RxBool isAddOrderCycleLoading = false.obs;

  RxBool isRepairFocus = false.obs;

  TextEditingController pendingController = TextEditingController();
  TextEditingController okPcsController = TextEditingController();
  TextEditingController woProcessController = TextEditingController();
  TextEditingController repairController = TextEditingController();
  RxInt previousRepair = 0.obs;

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;
    pendingController.text = arguments.pending?.toString() ?? '0';
    previousRepair.value = arguments.repair ?? 0;
  }

  String? validatePending(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPending.tr;
    } else if (value.toInt() < 0) {
      return AppStrings.invalidInputs.tr;
    }
    return null;
  }

  String? validateRepair(String? value) {
    if (value != null && value.isNotEmpty == true && value.toInt() > (int.tryParse(pendingController.text) ?? 0)) {
      return AppStrings.pleaseEnterValidRepair.tr;
    }
    return null;
  }

  Future<void> addOrderCycleApi() async {
    try {
      isAddOrderCycleLoading(true);
      final isValidate = addOrderCycleFormKey.currentState?.validate();
      if (isValidate == true) {
        final response = await OrderServices.createOrderCycleService(
          orderMetaId: arguments.itemId ?? '',
          okPcs: okPcsController.text.trim().isEmpty ? "0" : okPcsController.text.trim(),
          woProcess: woProcessController.text.trim().isEmpty ? "0" : woProcessController.text.trim(),
          repair: finalRepairCalculation().toString(),
        );
        if (response.isSuccess) {
          Get.back();
          Utils.handleMessage(message: response.message);
          await Get.find<OrderDetailsController>().getOrdersApi(isLoading: false);
        }
      }
    } finally {
      isAddOrderCycleLoading(false);
    }
  }

  int finalRepairCalculation() {
    if (int.tryParse(pendingController.text) != null) {
      return pendingController.text.toInt();
    }
    return 0;
  }
}

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/add_order_cycle_screen/add_order_cycle_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddOrderCycleView extends GetView<AddOrderCycleController> {
  const AddOrderCycleView({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return UnfocusWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
            child: Form(
              key: controller.addOrderCycleFormKey,
              child: Column(
                children: [
                  ///Header
                  CustomHeaderWidget(
                    title: AppStrings.orderCycle.tr,
                    titleIcon: AppAssets.addOrderCycleIcon,
                    titleIconSize: 10.w,
                    onBackPressed: () {
                      Get.back(closeOverlays: true);
                    },
                  ),
                  SizedBox(height: 4.h),

                  ///Fields
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: keyboardPadding != 0
                              ? keyboardPadding - 6.h > 0
                                  ? keyboardPadding - 6.h
                                  : keyboardPadding
                              : 0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ///Pending
                            IgnorePointer(
                              ignoring: true,
                              child: TextFieldWidget(
                                controller: controller.pendingController,
                                title: AppStrings.pending.tr,
                                hintText: AppStrings.enterPending.tr,
                                validator: controller.validatePending,
                                textInputAction: TextInputAction.next,
                                maxLength: 30,
                              ),
                            ),
                            SizedBox(height: 2.h),

                            ///Ok pcs.
                            TextFieldWidget(
                              controller: controller.okPcsController,
                              title: AppStrings.okPcs.tr,
                              hintText: AppStrings.enterOkPcs.tr,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              maxLength: 30,
                              inputFormatters: [
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  if (!newValue.text.isNumericOnly && newValue.text.isNotEmpty) {
                                    return oldValue;
                                  } else {
                                    return newValue;
                                  }
                                })
                              ],
                              onChanged: (value) {
                                if (value.isNumericOnly) {
                                  controller.pendingController.text = controller.arguments.pending?.toString() ?? '0';
                                  controller.pendingController.text = "${controller.pendingController.text.toInt() - value.toInt() - (controller.woProcessController.text.isEmpty ? 0 : controller.woProcessController.text.toInt())}";
                                } else {
                                  controller.pendingController.text = "${(controller.arguments.pending ?? 0) - (controller.woProcessController.text.isEmpty ? 0 : controller.woProcessController.text.toInt())}";
                                }
                                if (controller.pendingController.text.trim() == "0") {
                                  if (controller.woProcessController.text.isEmpty) {
                                    controller.woProcessController.text = "0";
                                  }
                                  if (controller.repairController.text.isEmpty) {
                                    controller.repairController.text = "0";
                                  }
                                }
                              },
                            ),
                            SizedBox(height: Utils.getHeightByDevDevice(height: 418.88)),

                            ///W/O Process & Repair
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: TextFieldWidget(
                                    controller: controller.woProcessController,
                                    title: AppStrings.woProcess.tr,
                                    hintText: AppStrings.enterWOProcess.tr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    contentPadding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 3.w : 3.h, vertical: context.isPortrait ? 3.h : 3.w).copyWith(right: context.isPortrait ? 1.5.w : 1.5.h),
                                    maxLength: 30,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    onChanged: (value) {
                                      if (value.isNumericOnly) {
                                        controller.pendingController.text = controller.arguments.pending?.toString() ?? '0';
                                        controller.pendingController.text = "${controller.pendingController.text.toInt() - value.toInt() - (controller.okPcsController.text.isEmpty ? 0 : controller.okPcsController.text.toInt())}";
                                      } else {
                                        controller.pendingController.text = "${(controller.arguments.pending ?? 0) - (controller.okPcsController.text.isEmpty ? 0 : controller.okPcsController.text.toInt())}";
                                      }
                                      if (controller.pendingController.text.trim() == "0") {
                                        if (controller.okPcsController.text.isEmpty) {
                                          controller.okPcsController.text = "0";
                                        }
                                        if (controller.repairController.text.isEmpty) {
                                          controller.repairController.text = "0";
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Flexible(
                                  child: TextFieldWidget(
                                    controller: controller.repairController,
                                    title: AppStrings.repair.tr,
                                    hintText: AppStrings.enterRepair.tr,
                                    validator: controller.validateRepair,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    maxLength: 30,
                                    contentPadding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 3.w : 3.h, vertical: context.isPortrait ? 3.h : 3.w).copyWith(right: context.isPortrait ? 1.5.w : 1.5.h),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  ///Add Order Cycle Button
                  Obx(() {
                    return ButtonWidget(
                      onPressed: () async {
                        Utils.unfocus();
                        await controller.addOrderCycleApi();
                      },
                      isLoading: controller.isAddOrderCycleLoading.value,
                      buttonTitle: AppStrings.add.tr,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/add_order_cycle_screen/add_order_cycle_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddOrderCycleView extends GetView<AddOrderCycleController> {
  const AddOrderCycleView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
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
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.addOrderCycleFormKey,
                      child: Column(
                        children: [
                          ///Pending
                          IgnorePointer(
                            ignoring: true,
                            child: TextFieldWidget(
                              controller: controller.pendingController,
                              title: AppStrings.pending,
                              hintText: AppStrings.enterPending,
                              validator: controller.validatePending,
                              textInputAction: TextInputAction.next,
                              maxLength: 30,
                            ),
                          ),
                          SizedBox(height: 2.h),

                          ///Ok pcs.
                          TextFieldWidget(
                            controller: controller.okPcsController,
                            title: AppStrings.okPcs,
                            hintText: AppStrings.enterOkPcs,
                            validator: controller.validateOkPcs,
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
                            },
                          ),
                          SizedBox(height: 2.h),

                          ///W/O Process
                          TextFieldWidget(
                            controller: controller.woProcessController,
                            title: AppStrings.woProcess,
                            hintText: AppStrings.enterWOProcess,
                            validator: controller.validateWOProcess,
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
                                controller.pendingController.text = "${controller.pendingController.text.toInt() - value.toInt() - (controller.okPcsController.text.isEmpty ? 0 : controller.okPcsController.text.toInt())}";
                              } else {
                                controller.pendingController.text = "${(controller.arguments.pending ?? 0) - (controller.okPcsController.text.isEmpty ? 0 : controller.okPcsController.text.toInt())}";
                              }
                            },
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

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
    );
  }
}

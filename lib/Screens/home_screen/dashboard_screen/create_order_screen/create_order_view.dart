import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_controller.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateOrderView extends GetView<CreateOrderController> {
  const CreateOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
            child: Column(
              children: [
                ///Header
                CustomHeaderWidget(
                  title: AppStrings.createOrder.tr,
                  titleIcon: AppAssets.createOrderImage,
                  onBackPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(height: 4.h),

                ///Fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.createOrderFormKey,
                      child: Column(
                        children: [
                          ///Item Name
                          TextFieldWidget(
                            controller: controller.itemNameController,
                            title: AppStrings.itemName,
                            hintText: AppStrings.enterItemName,
                            validator: controller.validateItemName,
                            textInputAction: TextInputAction.next,
                            maxLength: 30,
                          ),
                          SizedBox(height: 2.h),

                          ///PVD Color
                          TextFieldWidget(
                            controller: controller.pvdColorController,
                            title: AppStrings.pvdColor,
                            hintText: AppStrings.enterPVDColor,
                            validator: controller.validatePVDColor,
                            textInputAction: TextInputAction.next,
                            maxLength: 30,
                          ),
                          SizedBox(height: 2.h),

                          ///Quantity
                          TextFieldWidget(
                            controller: controller.quantityController,
                            title: AppStrings.quantity,
                            hintText: AppStrings.enterQuantity,
                            validator: controller.validateQuantity,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                          ),
                          SizedBox(height: 2.h),

                          ///Size
                          TextFieldWidget(
                            controller: controller.sizeController,
                            title: AppStrings.size,
                            hintText: AppStrings.enterSize,
                            validator: controller.validateSize,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                          ),
                          SizedBox(height: 2.h),

                          ///OK Pcs.
                          TextFieldWidget(
                            controller: controller.okPcsController,
                            title: AppStrings.okPcs,
                            hintText: AppStrings.enterOkPcs,
                            validator: controller.validateOkPcs,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                          ),
                          SizedBox(height: 2.h),

                          ///Rejected
                          TextFieldWidget(
                            controller: controller.rejectedController,
                            title: AppStrings.rejected,
                            hintText: AppStrings.enterRejected,
                            validator: controller.validateRejected,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                          ),
                          SizedBox(height: 2.h),

                          ///Pending
                          TextFieldWidget(
                            controller: controller.pendingController,
                            title: AppStrings.pending,
                            hintText: AppStrings.enterPending,
                            validator: controller.validatePending,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                ///Create Order Button
                ButtonWidget(
                  onPressed: () async {
                    await controller.createOrderApi();
                  },
                  isLoading: controller.isCreateOrderLoading.value,
                  buttonTitle: AppStrings.createOrder.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

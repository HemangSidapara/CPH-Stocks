import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_controller.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateOrderView extends GetView<CreateOrderController> {
  const CreateOrderView({super.key});

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
                          /// Party List
                          Padding(
                            padding: EdgeInsets.only(left: context.isPortrait ? 2.w : 1.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.partyName.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: context.isPortrait ? 16.sp : 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.createOrderFormKey.currentState?.reset();
                                    controller.selectedParty(-1);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    maximumSize: Size(10.w, 5.h),
                                    minimumSize: Size(10.w, 2.h),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    AppStrings.reset.tr,
                                    style: TextStyle(
                                      color: AppColors.LIGHT_BLUE_COLOR,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Obx(() {
                            return DropdownSearch<get_parties.Data>(
                              autoValidateMode: AutovalidateMode.onUserInteraction,
                              asyncItems: (text) async {
                                return controller.getPartiesApi();
                              },
                              selectedItem: controller.selectedParty.value == -1 ? null : controller.partyList[controller.selectedParty.value],
                              dropdownButtonProps: DropdownButtonProps(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.SECONDARY_COLOR,
                                  size: 5.w,
                                ),
                              ),
                              validator: controller.validatePartyList,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                baseStyle: TextStyle(
                                  color: AppColors.SECONDARY_COLOR,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                                dropdownSearchDecoration: InputDecoration(
                                  filled: true,
                                  enabled: true,
                                  fillColor: AppColors.WHITE_COLOR,
                                  hintText: AppStrings.selectParty.tr,
                                  hintStyle: TextStyle(
                                    color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  errorStyle: TextStyle(
                                    color: AppColors.ERROR_COLOR,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.ERROR_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.ERROR_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0).copyWith(right: 1.w),
                                ),
                              ),
                              itemAsString: (item) {
                                return item.partyName ?? '';
                              },
                              popupProps: PopupProps.menu(
                                menuProps: MenuProps(
                                  backgroundColor: AppColors.WHITE_COLOR,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                loadingBuilder: (context, searchEntry) {
                                  return const Center(
                                    child: LoadingWidget(),
                                  );
                                },
                                emptyBuilder: (context, searchEntry) {
                                  return Center(
                                    child: Text(
                                      AppStrings.noDataFound.tr,
                                      style: TextStyle(
                                        color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
                                        fontSize: context.isPortrait ? 10.sp : 5.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context, item, isSelected) {
                                  return TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      controller.selectedParty.value = controller.partyList.indexWhere((element) => element.orderId == item.orderId);
                                      if (controller.selectedParty.value != -1) {
                                        controller.partyNameController.text = controller.partyList[controller.selectedParty.value].partyName ?? '';
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 5.w : 5.h, vertical: context.isPortrait ? 1.h : 1.w),
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    ),
                                    child: Text(
                                      item.partyName ?? '',
                                      style: TextStyle(
                                        color: AppColors.SECONDARY_COLOR,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                                interceptCallBacks: true,
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  cursorColor: AppColors.TERTIARY_COLOR,
                                  style: TextStyle(
                                    color: AppColors.SECONDARY_COLOR,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchParty.tr,
                                    hintStyle: TextStyle(
                                      color: AppColors.HINT_GREY_COLOR,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: AppColors.SECONDARY_COLOR),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(width: 1, color: AppColors.SECONDARY_COLOR),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 4.w : 4.h, vertical: context.isPortrait ? 1.2.h : 1.2.w),
                                  ),
                                ),
                              ),
                            );
                          }),
                          SizedBox(height: 1.h),

                          ///Party Name
                          TextFieldWidget(
                            controller: controller.partyNameController,
                            hintText: AppStrings.enterPartyName,
                            validator: controller.validatePartyName,
                            textInputAction: TextInputAction.next,
                            maxLength: 30,
                            isDisable: controller.selectedParty.value != -1,
                          ),
                          SizedBox(height: 2.h),

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

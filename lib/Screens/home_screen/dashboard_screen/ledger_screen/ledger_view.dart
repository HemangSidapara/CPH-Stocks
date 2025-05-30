import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/ledger_screen/ledger_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LedgerView extends GetView<LedgerController> {
  const LedgerView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
            child: Column(
              children: [
                ///Header
                CustomHeaderWidget(
                  title: AppStrings.ledger.tr,
                  titleIcon: AppAssets.ledgerIcon,
                  onBackPressed: () {
                    Get.back(closeOverlays: true);
                  },
                  titleIconSize: 9.w,
                ),
                SizedBox(height: 2.h),

                ///Ledger Details
                Expanded(
                  child: Form(
                    key: controller.ledgerFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ///Party
                          TextFieldWidget(
                            controller: controller.partyNameController,
                            readOnly: true,
                            title: AppStrings.party.tr,
                            hintText: AppStrings.selectParty.tr,
                            validator: controller.validatePartyName,
                            onTap: () {
                              CreateOrderView().showBottomSheetSelectAndAdd(
                                ctx: context,
                                selectOnly: true,
                                items: controller.partyList,
                                title: AppStrings.party.tr,
                                fieldHint: AppStrings.enterPartyName.tr,
                                searchHint: AppStrings.searchParty.tr,
                                selectedId: controller.selectedParty.isNotEmpty ? controller.selectedParty.value.toInt() : -1,
                                controller: controller.partyNameController,
                                onInit: () async {
                                  return await controller.getPartiesApi();
                                },
                                onSelect: (id) {
                                  controller.selectedParty.value = id.toString();
                                  controller.partyNameController.text = controller.partyList.firstWhereOrNull((element) => element.orderId == controller.selectedParty.value)?.partyName ?? "";
                                },
                              );
                            },
                          ),
                          SizedBox(height: 2.h),

                          ///Start Date
                          TextFieldWidget(
                            controller: controller.startDateController,
                            readOnly: true,
                            title: AppStrings.startDate.tr,
                            hintText: "2025-01-01",
                            validator: controller.validateStartDate,
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 50),
                                lastDate: controller.endDateController.text.isNotEmpty ? DateFormat("yyyy-MM-dd").parse(controller.endDateController.text) : DateTime(DateTime.now().year + 50),
                                builder: (context, child) {
                                  return themeData(context: context, child: child!);
                                },
                              ).then((value) {
                                if (value != null) {
                                  controller.startDateController.text = DateFormat("yyyy-MM-dd").format(value);
                                }
                              });
                            },
                          ),
                          SizedBox(height: 2.h),

                          ///End Date
                          TextFieldWidget(
                            controller: controller.endDateController,
                            readOnly: true,
                            title: AppStrings.endDate.tr,
                            hintText: "2025-01-31",
                            validator: controller.validateEndDate,
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: controller.startDateController.text.isNotEmpty ? DateFormat("yyyy-MM-dd").parse(controller.startDateController.text) : DateTime(DateTime.now().year - 50),
                                lastDate: DateTime(DateTime.now().year + 50),
                                builder: (context, child) {
                                  return themeData(context: context, child: child!);
                                },
                              ).then((value) {
                                if (value != null) {
                                  controller.endDateController.text = DateFormat("yyyy-MM-dd").format(value);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                ///Generate
                Obx(() {
                  return ButtonWidget(
                    onPressed: () {
                      controller.generateLedgerApi();
                    },
                    isLoading: controller.isGenerateLoading.isTrue,
                    buttonTitle: AppStrings.generate.tr,
                  );
                }),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Theme themeData({
    required BuildContext context,
    required Widget child,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: AppColors.SECONDARY_COLOR,
          onPrimary: AppColors.PRIMARY_COLOR,
          onSurface: AppColors.SECONDARY_COLOR,
          surface: AppColors.PRIMARY_COLOR,
        ),
        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: AppColors.SECONDARY_COLOR,
          backgroundColor: AppColors.PRIMARY_COLOR,
          headerHeadlineStyle: AppStyles.size22w900,
          headerForegroundColor: AppColors.PRIMARY_COLOR,
          dividerColor: AppColors.TRANSPARENT,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.SECONDARY_COLOR,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.SECONDARY_COLOR,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.SECONDARY_COLOR,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.DARK_RED_COLOR,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.SECONDARY_COLOR,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.DARK_RED_COLOR,
                width: 1,
              ),
            ),
            labelStyle: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
          ),
        ),
      ),
      child: child,
    );
  }
}

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/ledger_screen/ledger_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                        Spacer(),

                        ///Generate
                        Obx(() {
                          return ButtonWidget(
                            onPressed: () {},
                            isLoading: controller.isGenerateLoading.isTrue,
                            buttonTitle: AppStrings.generate.tr,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

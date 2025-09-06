import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/account_models/get_automatic_ledger_invoice_model.dart';
import 'package:cph_stocks/Network/models/account_models/get_payment_ledger_model.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart' as get_invoices;
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/ledger_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/refresh_indicator_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LedgerView extends GetView<LedgerController> {
  final bool isPaymentLedger;

  const LedgerView({
    super.key,
    this.isPaymentLedger = false,
  });

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.TRANSPARENT,
          leadingWidth: 0,
          leading: SizedBox.shrink(),
          actionsPadding: EdgeInsets.zero,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomHeaderWidget(
                title: isPaymentLedger ? AppStrings.paymentLedger.tr : AppStrings.ledger.tr,
                titleIcon: AppAssets.ledgerIcon,
                onBackPressed: () {
                  Get.back(closeOverlays: true);
                },
                titleIconSize: 9.w,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Column(
              children: [
                ///Tabs
                TabBar(
                  controller: controller.tabController,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  tabAlignment: TabAlignment.fill,
                  labelPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  indicatorPadding: EdgeInsets.zero,
                  indicatorColor: AppColors.TERTIARY_COLOR,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 2.5,
                  indicator: UnderlineTabIndicator(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.TERTIARY_COLOR,
                      width: 2.5,
                    ),
                  ),
                  dividerColor: AppColors.TRANSPARENT,
                  onTap: (value) {
                    Utils.unfocus();
                    controller.tabIndex(value);
                  },
                  tabs: [
                    Text(
                      AppStrings.monthly.tr,
                      style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      AppStrings.custom.tr,
                      style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                ///Details
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      ///Automatic Ledger
                      RefreshIndicatorWidget(
                        onRefresh: () async {
                          if (isPaymentLedger) {
                            await controller.getAutomaticLedgerPaymentApiCall(isRefresh: true);
                          } else {
                            await controller.getAutomaticLedgerInvoiceApiCall(isRefresh: true);
                          }
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 1.h),

                            ///Search Party & Filter
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                children: [
                                  ///Search
                                  Expanded(
                                    child: TextFieldWidget(
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: AppColors.SECONDARY_COLOR,
                                        size: 5.w,
                                      ),
                                      prefixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 8.w, minWidth: 8.w),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          Utils.unfocus();
                                          controller.searchPartyNameController.clear();
                                          controller.searchParty(controller.searchPartyNameController.text);
                                        },
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: AppColors.SECONDARY_COLOR,
                                          size: 5.w,
                                        ),
                                      ),
                                      suffixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 12.w, minWidth: 12.w),
                                      hintText: AppStrings.searchParty.tr,
                                      controller: controller.searchPartyNameController,
                                      onChanged: (value) {
                                        controller.searchParty(value);
                                      },
                                    ),
                                  ),

                                  if (Get.arguments == true) ...[
                                    SizedBox(width: 2.w),

                                    ///Pending Payments Pdf
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.showPendingPdfBottomSheet(ctx: context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.BRONZE_COLOR,
                                        elevation: 4,
                                        maximumSize: Size.square(8.w),
                                        minimumSize: Size.square(8.w),
                                        padding: EdgeInsets.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Image.asset(
                                        AppAssets.pendingPaymentIcon,
                                        width: 5.w,
                                        height: 5.w,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),

                                    ///GST Filter
                                    Obx(() {
                                      return ElevatedButton(
                                        onPressed: () {
                                          controller.isGstFilteredParties.toggle();
                                          controller.searchParty(controller.searchPartyNameController.text);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: controller.isGstFilteredParties.isTrue ? AppColors.DARK_GREEN_COLOR : AppColors.WARNING_COLOR,
                                          elevation: 4,
                                          maximumSize: Size.square(8.w),
                                          minimumSize: Size.square(8.w),
                                          padding: EdgeInsets.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Image.asset(
                                          AppAssets.gstIcon,
                                          width: 5.w,
                                          height: 5.w,
                                          color: AppColors.PRIMARY_COLOR,
                                        ),
                                      );
                                    }),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 1.h),

                            Expanded(
                              child: Obx(() {
                                if (controller.isMonthlyLedgerLoading.isTrue) {
                                  return LoadingWidget();
                                } else if (isPaymentLedger ? controller.searchAutomaticLedgerList.isEmpty : controller.searchAutomaticLedgerInvoiceList.isEmpty) {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: NoDataFoundWidget(
                                        subtitle: AppStrings.noDataFound.tr,
                                        onPressed: () {
                                          Utils.unfocus();
                                          controller.searchPartyNameController.clear();
                                          if (isPaymentLedger) {
                                            controller.getAutomaticLedgerPaymentApiCall();
                                          } else {
                                            controller.getAutomaticLedgerInvoiceApiCall();
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  return AnimationLimiter(
                                    child: ListView.separated(
                                      itemCount: isPaymentLedger ? controller.searchAutomaticLedgerList.length : controller.searchAutomaticLedgerInvoiceList.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h).copyWith(top: 1.h),
                                      itemBuilder: (context, index) {
                                        final data = isPaymentLedger ? controller.searchAutomaticLedgerList[index] : controller.searchAutomaticLedgerInvoiceList[index];

                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: Card(
                                                color: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                                clipBehavior: Clip.antiAlias,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: ExpansionTile(
                                                  title: Row(
                                                    children: [
                                                      ///Party Name
                                                      Expanded(
                                                        child: Text(
                                                          isPaymentLedger ? (data as GetPaymentLedgerModel).partyName ?? "" : (data as GetPartyData).partyName ?? "",
                                                          style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2.w),
                                                    ],
                                                  ),
                                                  tilePadding: EdgeInsets.only(left: 3.w, right: 2.w),
                                                  trailing: ElevatedButton(
                                                    onPressed: () {
                                                      List<get_invoices.OrderInvoice> ledgerInvoiceData = [];
                                                      if (isPaymentLedger) {
                                                        ledgerInvoiceData = controller.automaticLedgerInvoiceList.firstWhereOrNull((element) => element.partyId == (data as GetPaymentLedgerModel).partyId)?.invoices ?? [];
                                                      } else {
                                                        ledgerInvoiceData = (data as GetPartyData).invoices ?? [];
                                                      }
                                                      controller.showInvoiceBottomSheet(
                                                        ctx: context,
                                                        ledgerInvoiceData: ledgerInvoiceData,
                                                        paymentLedgerInvoiceData: isPaymentLedger ? (data as GetPaymentLedgerModel) : null,
                                                        isPaymentLedger: isPaymentLedger,
                                                        startDate: !isPaymentLedger ? ((data as GetPartyData).startDate) : (data as GetPaymentLedgerModel).startDate,
                                                        endDate: !isPaymentLedger ? ((data as GetPartyData).endDate) : (data as GetPaymentLedgerModel).endDate,
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColors.WARNING_COLOR,
                                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      padding: EdgeInsets.zero,
                                                      maximumSize: Size.square(8.w),
                                                      minimumSize: Size.square(8.w),
                                                      elevation: 4,
                                                    ),
                                                    child: Icon(
                                                      Icons.visibility_rounded,
                                                      size: 5.w,
                                                      color: AppColors.PRIMARY_COLOR,
                                                    ),
                                                  ),
                                                  dense: true,
                                                  collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                                  backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                                  iconColor: AppColors.SECONDARY_COLOR,
                                                  collapsedShape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    side: BorderSide.none,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    side: BorderSide.none,
                                                  ),
                                                  childrenPadding: EdgeInsets.only(bottom: 2.h),
                                                  enabled: isPaymentLedger,
                                                  children: isPaymentLedger
                                                      ? [
                                                          DividerWidget(color: AppColors.SECONDARY_COLOR.withValues(alpha: 0.35)),

                                                          ///Total Invoice Amount
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "${AppStrings.totalInvoiceAmount.tr}: ",
                                                                  style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                                ),
                                                                Text(
                                                                  isPaymentLedger ? ((data as GetPaymentLedgerModel).summary?.totalInvoiceAmount != null ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.summary?.totalInvoiceAmount) : "") : "",
                                                                  style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          ///Total Payment Amount
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "${AppStrings.totalPaymentAmount.tr}: ",
                                                                  style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                                ),
                                                                Text(
                                                                  isPaymentLedger ? ((data as GetPaymentLedgerModel).summary?.totalPaymentAmount != null ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.summary?.totalPaymentAmount) : "") : "",
                                                                  style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          ///Pending Amount
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "${AppStrings.pendingAmount.tr}: ",
                                                                  style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                                ),
                                                                Text(
                                                                  isPaymentLedger ? ((data as GetPaymentLedgerModel).summary?.pendingAmount != null ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.summary?.pendingAmount) : "") : "",
                                                                  style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 1.5.h);
                                      },
                                    ),
                                  );
                                }
                              }),
                            ),
                          ],
                        ),
                      ),

                      ///Custom Ledger
                      CustomLedgerView(ctx: context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomLedgerView({required BuildContext ctx}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
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
                          ctx: ctx,
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
                      hintText: "01/01/2025",
                      validator: controller.validateStartDate,
                      onTap: () async {
                        await showDatePicker(
                          context: ctx,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 50),
                          lastDate: controller.endDateController.text.isNotEmpty ? DateFormat("dd/MM/yyyy").parse(controller.endDateController.text) : DateTime(DateTime.now().year + 50),
                          builder: (context, child) {
                            return themeData(context: context, child: child!);
                          },
                        ).then((value) {
                          if (value != null) {
                            controller.startDateController.text = DateFormat("dd/MM/yyyy").format(value);
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
                      hintText: "31/01/2025",
                      validator: controller.validateEndDate,
                      onTap: () async {
                        await showDatePicker(
                          context: ctx,
                          initialDate: DateTime.now(),
                          firstDate: controller.startDateController.text.isNotEmpty ? DateFormat("dd/MM/yyyy").parse(controller.startDateController.text) : DateTime(DateTime.now().year - 50),
                          lastDate: DateTime(DateTime.now().year + 50),
                          builder: (context, child) {
                            return themeData(context: context, child: child!);
                          },
                        ).then((value) {
                          if (value != null) {
                            controller.endDateController.text = DateFormat("dd/MM/yyyy").format(value);
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
                controller.generateLedgerApi(isPaymentLedger: isPaymentLedger);
              },
              isLoading: controller.isGenerateLoading.isTrue,
              buttonTitle: AppStrings.generate.tr,
            );
          }),
          SizedBox(height: 2.h),
        ],
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

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/account_models/get_party_payment_model.dart' as get_payments;
import 'package:cph_stocks/Screens/home_screen/account_screen/payment_details_screen/payment_details_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/refresh_indicator_widget.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:cph_stocks/Widgets/show_delete_dialog_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentDetailsView extends GetView<PaymentDetailsController> {
  const PaymentDetailsView({super.key});

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
                title: AppStrings.paymentDetails.tr,
                titleIcon: AppAssets.paymentDetailsIcon,
                titleIconSize: 10.w,
                onBackPressed: () {
                  Get.back(closeOverlays: true);
                },
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
                      AppStrings.allPayments.tr,
                      style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      AppStrings.addPayment.tr,
                      style: TextStyle(
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      ///All Payments
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ///Filter
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: ElevatedButton(
                              onPressed: () async {
                                await showDialogDateRangePicker(ctx: context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.FACEBOOK_BLUE_COLOR,
                                elevation: 4,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size.square(8.w),
                                maximumSize: Size.square(8.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                color: AppColors.WHITE_COLOR,
                                size: 5.w,
                              ),
                            ),
                          ),

                          ///Payments
                          Expanded(
                            child: RefreshIndicatorWidget(
                              onRefresh: () async {
                                await controller.getAllPaymentsApiCall(isRefresh: true);
                              },
                              child: Obx(() {
                                if (controller.isPaymentsLoading.isTrue) {
                                  return SizedBox(
                                    height: 70.h,
                                    child: Center(
                                      child: LoadingWidget(),
                                    ),
                                  );
                                } else if (controller.filteredAllPaymentsList.isEmpty) {
                                  return SizedBox(
                                    height: 70.h,
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: NoDataFoundWidget(
                                          subtitle: AppStrings.noPaymentsFound.tr,
                                          onPressed: () {
                                            Utils.unfocus();
                                            controller.getAllPaymentsApiCall();
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return AnimationLimiter(
                                    child: ListView.separated(
                                      itemCount: controller.filteredAllPaymentsList.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h).copyWith(top: 1.h),
                                      itemBuilder: (context, index) {
                                        final data = controller.filteredAllPaymentsList[index];
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
                                                  title: Column(
                                                    children: [
                                                      ///Name & Amount
                                                      Row(
                                                        children: [
                                                          ///Party Name
                                                          Expanded(
                                                            child: Text(
                                                              data.partyName ?? "",
                                                              style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                            ),
                                                          ),
                                                          SizedBox(width: 2.w),

                                                          ///Pending Amount
                                                          Text(
                                                            data.amount != null ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.amount?.toTryDouble() ?? 0.0) : "",
                                                            style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0.7.h),

                                                      ///Date & Mode
                                                      Row(
                                                        children: [
                                                          ///Party Name
                                                          Expanded(
                                                            child: Text(
                                                              DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.parse("${data.createdDate ?? ""} ${data.createdTime ?? ""}")),
                                                              style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                            ),
                                                          ),
                                                          SizedBox(width: 2.w),

                                                          ///Pending Amount
                                                          Text(
                                                            data.paymentMode?.tr ?? "",
                                                            style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  enabled: false,
                                                  tilePadding: EdgeInsets.symmetric(horizontal: 3.w),
                                                  dense: true,
                                                  showTrailingIcon: false,
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
                          ),
                        ],
                      ),

                      ///Add Payment
                      Column(
                        children: [
                          SizedBox(height: 1.h),
                          Form(
                            key: controller.formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///Party
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: controller.partyNameController,
                                          readOnly: true,
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
                                      ),
                                      SizedBox(width: 2.w),

                                      ///Add Payment Enable
                                      IconButton(
                                        onPressed: () {
                                          controller.isPaymentAddEnable.toggle();
                                        },
                                        style: IconButton.styleFrom(
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(context.isPortrait ? 7.w : 7.h, context.isPortrait ? 4.h : 4.w),
                                          maximumSize: Size(context.isPortrait ? 7.w : 7.h, context.isPortrait ? 4.h : 4.w),
                                        ),
                                        icon: Obx(() {
                                          return AnimatedRotation(
                                            turns: controller.isPaymentAddEnable.isTrue ? 1 / 2 : 0,
                                            duration: 375.milliseconds,
                                            child: Icon(
                                              Icons.add_circle_rounded,
                                              color: controller.isPaymentAddEnable.isTrue ? AppColors.DARK_GREEN_COLOR : AppColors.WHITE_COLOR,
                                              size: context.isPortrait ? 7.w : 7.h,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),

                                  ///Fields
                                  Obx(() {
                                    if (controller.isPaymentAddEnable.isTrue) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 2.h),

                                          ///Amount
                                          TextFieldWidget(
                                            controller: controller.amountController,
                                            title: AppStrings.amount.tr,
                                            hintText: AppStrings.enterAmount.tr,
                                            validator: controller.validateAmount,
                                            keyboardType: TextInputType.number,
                                            maxLength: 10,
                                          ),
                                          SizedBox(height: 2.h),

                                          ///Payment Mode
                                          TextFieldWidget(
                                            controller: controller.paymentModeController,
                                            readOnly: true,
                                            title: AppStrings.paymentMode.tr,
                                            hintText: AppStrings.selectPaymentMode.tr,
                                            validator: controller.validatePaymentMode,
                                            onTap: () {
                                              CreateOrderView().showBottomSheetSelectAndAdd(
                                                ctx: context,
                                                selectOnly: true,
                                                items: controller.paymentModeList,
                                                title: AppStrings.paymentMode.tr,
                                                fieldHint: "",
                                                searchHint: AppStrings.searchPaymentMode.tr,
                                                selectedId: controller.selectedPaymentMode.value,
                                                controller: controller.paymentModeController,
                                                onSelect: (id) {
                                                  controller.selectedPaymentMode.value = id;
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  }),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          ///Get/Add Payment
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 1.5.h),
                            child: Obx(() {
                              return ButtonWidget(
                                onPressed: () {
                                  if (controller.isPaymentAddEnable.isTrue) {
                                    controller.createPaymentApiCall();
                                  } else {
                                    controller.getPartyPaymentApiCall();
                                  }
                                },
                                isLoading: controller.isPaymentAddEnable.isTrue ? controller.isPaymentAdding.isTrue : controller.isLoading.isTrue,
                                buttonTitle: controller.isPaymentAddEnable.isTrue ? AppStrings.addPayment.tr : AppStrings.getPayments.tr,
                              );
                            }),
                          ),
                          DividerWidget(),

                          ///Payments
                          Expanded(
                            child: RefreshIndicatorWidget(
                              onRefresh: () async {
                                await controller.getPartyPaymentApiCall(isRefresh: true);
                              },
                              child: Obx(() {
                                if (controller.isLoading.isTrue) {
                                  return LoadingWidget();
                                } else if (controller.filteredPaymentList.isEmpty) {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: NoDataFoundWidget(
                                        subtitle: AppStrings.noPaymentsFound.tr,
                                        onPressed: () {
                                          controller.getPartyPaymentApiCall();
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  return AnimationLimiter(
                                    child: ListView.separated(
                                      itemCount: controller.filteredPaymentList.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h).copyWith(bottom: 5.h),
                                      itemBuilder: (context, index) {
                                        final data = controller.filteredPaymentList[index];
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
                                                      ///Amount & Date
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              data.amount?.isNotEmpty == true ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.amount?.toDouble()) : "",
                                                              style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                            ),
                                                            Text(
                                                              DateFormat("dd/MM/yyyy").format(DateTime.parse("${data.createdDate ?? ""} ${data.createdTime ?? ""}".trim())),
                                                              style: AppStyles.size14w600.copyWith(color: AppColors.ORANGE_COLOR),
                                                            ),
                                                            Text(
                                                              DateFormat("hh:mm a").format(DateTime.parse("${data.createdDate ?? ""} ${data.createdTime ?? ""}".trim())),
                                                              style: AppStyles.size14w600.copyWith(color: AppColors.ORANGE_COLOR),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 2.w),

                                                      ///Payment Mode
                                                      Text(
                                                        data.paymentMode ?? "",
                                                        style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                      ),
                                                      SizedBox(width: 2.w),
                                                    ],
                                                  ),
                                                  enabled: false,
                                                  tilePadding: EdgeInsets.only(left: 3.w, right: 2.w),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      ///Edit
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          showBottomSheetEditPayment(ctx: context, paymentData: data);
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
                                                          Icons.edit_rounded,
                                                          size: 5.w,
                                                          color: AppColors.PRIMARY_COLOR,
                                                        ),
                                                      ),
                                                      SizedBox(width: 2.w),

                                                      ///Delete
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          showDeleteDialog(
                                                            ctx: context,
                                                            onPressed: () {
                                                              Get.back();
                                                              controller.deletePaymentApiCall(partyPaymentMetaId: data.partyPaymentMetaId);
                                                            },
                                                            title: AppStrings.areYouSureYouWantToDeleteThisPayment.tr,
                                                          );
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: AppColors.DARK_RED_COLOR,
                                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                          padding: EdgeInsets.zero,
                                                          maximumSize: Size.square(8.w),
                                                          minimumSize: Size.square(8.w),
                                                          elevation: 4,
                                                        ),
                                                        child: Icon(
                                                          Icons.delete_forever_rounded,
                                                          size: 5.w,
                                                          color: AppColors.PRIMARY_COLOR,
                                                        ),
                                                      ),
                                                    ],
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
                          ),
                        ],
                      ),
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

  Future<void> showBottomSheetEditPayment({
    required BuildContext ctx,
    required get_payments.PartyPaymentData paymentData,
  }) async {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController(text: paymentData.amount);
    TextEditingController paymentModeController = TextEditingController(text: paymentData.paymentMode);
    RxInt selectedPaymentMode = (controller.paymentModeList.indexOf(paymentData.paymentMode ?? "")).obs;

    RxBool isEditLoading = false.obs;

    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
        return UnfocusWidget(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: keyboardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Title & Back
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.editPayment.tr,
                            style: AppStyles.size18w600,
                          ),
                        ),
                        CloseButtonWidget(),
                      ],
                    ),
                  ),
                  DividerWidget(),

                  ///Fields
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            ///Amount
                            TextFieldWidget(
                              controller: amountController,
                              title: AppStrings.amount.tr,
                              hintText: AppStrings.enterAmount.tr,
                              validator: controller.validateAmount,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                            ),
                            SizedBox(height: 2.h),

                            ///Payment Mode
                            TextFieldWidget(
                              controller: paymentModeController,
                              readOnly: true,
                              title: AppStrings.paymentMode.tr,
                              hintText: AppStrings.selectPaymentMode.tr,
                              validator: controller.validatePaymentMode,
                              onTap: () {
                                CreateOrderView().showBottomSheetSelectAndAdd(
                                  ctx: context,
                                  selectOnly: true,
                                  items: controller.paymentModeList,
                                  title: AppStrings.paymentMode.tr,
                                  fieldHint: "",
                                  searchHint: AppStrings.searchPaymentMode.tr,
                                  selectedId: selectedPaymentMode.value,
                                  controller: paymentModeController,
                                  onSelect: (id) {
                                    selectedPaymentMode.value = id;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  ///Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
                    child: Obx(() {
                      return ButtonWidget(
                        onPressed: () async {
                          Utils.unfocus();
                          try {
                            isEditLoading(true);
                            if (formKey.currentState?.validate() ?? false) {
                              await controller.editPaymentApiCall(
                                partyPaymentMetaId: paymentData.partyPaymentMetaId ?? "",
                                amount: amountController.text.trim(),
                                paymentMode: controller.paymentModeList[selectedPaymentMode.value],
                              );
                            }
                          } finally {
                            isEditLoading(false);
                          }
                        },
                        isLoading: isEditLoading.isTrue,
                        buttonTitle: AppStrings.edit.tr,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DateTimeRange<DateTime>?> showDialogDateRangePicker({
    required BuildContext ctx,
  }) async {
    final range = await showDateRangePicker(
      context: ctx,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(DateTime.now().year + 2, 12, 31),
      initialDateRange: controller.filterDateRange.value,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: AppColors.PRIMARY_COLOR,
          ),
          child: child!,
        );
      },
    );
    if (range != null) {
      controller.filterDateRange.value = range;
      controller.filterAllPayments();
      return range;
    }
    return null;
  }
}

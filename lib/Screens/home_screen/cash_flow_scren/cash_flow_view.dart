import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/add_edit_cash_flow_widget.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_controller.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_pdf_view.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/refresh_indicator_widget.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:cph_stocks/Widgets/show_delete_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CashFlowView extends GetView<CashFlowController> {
  const CashFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Filter by Date & Export
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Obx(() {
              return Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await showDialogDateRangePicker(ctx: context);
                      controller.getCashFlowApiCall(isRefresh: true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.FACEBOOK_BLUE_COLOR,
                      elevation: 4,
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      maximumSize: Size(50.w, 8.w),
                      minimumSize: Size.square(8.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.WHITE_COLOR,
                          size: 5.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          controller.filterDateRange.value?.start != null ? DateFormat("dd/MM/yyyy").format(controller.filterDateRange.value!.start) : "-",
                          style: AppStyles.size14w600.copyWith(
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          "•",
                          style: AppStyles.size14w600.copyWith(
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          controller.filterDateRange.value?.end != null ? DateFormat("dd/MM/yyyy").format(controller.filterDateRange.value!.end) : "-",
                          style: AppStyles.size14w600.copyWith(
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  if (controller.filterDateRange.value != null) ...[
                    IconButton(
                      onPressed: () {
                        controller.filterDateRange.value = null;
                        controller.getCashFlowApiCall(isRefresh: true);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.TERTIARY_COLOR.withValues(alpha: 0.5),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.square(8.w),
                        maximumSize: Size.square(8.w),
                        padding: EdgeInsets.zero,
                      ),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.PRIMARY_COLOR,
                        size: 5.w,
                      ),
                    ),
                    SizedBox(width: 2.w),
                  ],
                  IconButton(
                    onPressed: () {
                      showExportBottomSheet(ctx: context);
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.ORANGE_COLOR,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.square(8.w),
                      maximumSize: Size.square(8.w),
                      padding: EdgeInsets.zero,
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.solidFilePdf,
                      color: AppColors.PRIMARY_COLOR,
                      size: 4.w,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        SizedBox(height: 1.h),

        ///Cash flow summary
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Obx(() {
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.PRIMARY_COLOR,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.7.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${AppStrings.inFlow.tr}:  ${NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(controller.getSummeryData.value.totalIn?.toDouble() ?? 0.0)}",
                            style: AppStyles.size16w600.copyWith(color: AppColors.DARK_GREEN_COLOR),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "${AppStrings.outFlow.tr}:  ${NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(controller.getSummeryData.value.totalOut?.toDouble() ?? 0.0)}",
                            style: AppStyles.size16w600.copyWith(color: AppColors.DARK_RED_COLOR),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.7.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${AppStrings.net.tr}:  ${NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(controller.getSummeryData.value.netBalance?.toDouble() ?? 0.0)}",
                            style: AppStyles.size16w600,
                          ),
                          SizedBox(width: 2.w),
                          Row(
                            children: [
                              Text(
                                controller.switchFilteredSummary.isTrue ? AppStrings.filtered.tr : AppStrings.all.tr,
                                style: AppStyles.size14w600,
                              ),
                              SizedBox(width: 2.w),
                              IconButton(
                                onPressed: () {
                                  controller.switchFilteredSummary.toggle();
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.ROSEGOLD_COLOR,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  maximumSize: Size.square(context.isTablet ? 8.h : 8.w),
                                  minimumSize: Size.square(context.isTablet ? 8.h : 8.w),
                                ),
                                icon: Obx(() {
                                  return AnimatedRotation(
                                    turns: controller.switchFilteredSummary.isTrue ? 0.5 : 0,
                                    duration: 375.milliseconds,
                                    filterQuality: FilterQuality.high,
                                    child: Icon(
                                      Icons.compare_arrows_rounded,
                                      color: AppColors.PRIMARY_COLOR,
                                      size: context.isTablet ? 5.h : 5.w,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 0.5.h),

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
            for (int i = 0; i < controller.tabTypes.length; i++) ...[
              Text(
                controller.tabTypes[i].tr,
                style: TextStyle(
                  color: AppColors.WHITE_COLOR,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              for (int i = 0; i < controller.tabTypes.length; i++) ...[
                RefreshIndicatorWidget(
                  onRefresh: () async {
                    await controller.getCashFlowApiCall(isRefresh: true);
                  },
                  child: Obx(() {
                    if (controller.isLoading.isTrue) {
                      return Center(
                        child: LoadingWidget(),
                      );
                    } else if ((i == 0 ? controller.searchCashCashFlowList : controller.searchOnlineCashFlowList).isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          child: NoDataFoundWidget(
                            subtitle: AppStrings.noCashFlowFound.tr,
                            onPressed: () {
                              Utils.unfocus();
                              controller.searchCashFlowController.clear();
                              controller.getCashFlowApiCall();
                            },
                          ),
                        ),
                      );
                    } else {
                      return AnimationLimiter(
                        child: ListView.separated(
                          itemCount: (i == 0 ? controller.searchCashCashFlowList : controller.searchOnlineCashFlowList).length,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h).copyWith(bottom: 2.h),
                          itemBuilder: (context, index) {
                            final data = (i == 0 ? controller.searchCashCashFlowList : controller.searchOnlineCashFlowList)[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Card(
                                    color: (data.cashType == "OUT" ? AppColors.DARK_RED_COLOR : AppColors.DARK_GREEN_COLOR).withValues(alpha: 0.7),
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ExpansionTile(
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ///Note
                                              Expanded(
                                                child: Text(
                                                  data.note ?? "",
                                                  style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                ),
                                              ),
                                              SizedBox(width: 2.w),

                                              ///Pending Amount
                                              Text(
                                                data.amount != null ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.amount?.toTryDouble() ?? 0.0) : "",
                                                style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                              ),
                                              SizedBox(width: 2.w),

                                              ///Edit
                                              IconButton(
                                                onPressed: () {
                                                  showBottomSheetAddEditCashFlow(
                                                    ctx: context,
                                                    cashFlowId: data.cashFlowId,
                                                  );
                                                },
                                                style: IconButton.styleFrom(
                                                  backgroundColor: AppColors.WARNING_COLOR,
                                                  maximumSize: Size.square(8.w),
                                                  minimumSize: Size.square(8.w),
                                                  padding: EdgeInsets.zero,
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                icon: Icon(
                                                  Icons.edit_rounded,
                                                  color: AppColors.PRIMARY_COLOR,
                                                  size: 5.w,
                                                ),
                                              ),
                                              SizedBox(width: 1.w),

                                              ///Delete
                                              IconButton(
                                                onPressed: () {
                                                  showDeleteDialog(
                                                    ctx: context,
                                                    title: AppStrings.areYouSureYouWantToDeleteThisCashFlowEntry.tr,
                                                    onPressed: () {
                                                      Get.back();
                                                      controller.deleteCashFlowApiCall(cashFlowId: data.cashFlowId ?? "");
                                                    },
                                                  );
                                                },
                                                style: IconButton.styleFrom(
                                                  backgroundColor: AppColors.DARK_RED_COLOR,
                                                  maximumSize: Size.square(8.w),
                                                  minimumSize: Size.square(8.w),
                                                  padding: EdgeInsets.zero,
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                icon: Obx(() {
                                                  if (controller.deletingId.value == data.cashFlowId) {
                                                    return SizedBox.square(
                                                      dimension: 3.5.w,
                                                      child: CircularProgressIndicator(
                                                        color: AppColors.PRIMARY_COLOR,
                                                        strokeWidth: 1.5,
                                                      ),
                                                    );
                                                  } else {
                                                    return Icon(
                                                      Icons.delete_rounded,
                                                      color: AppColors.WHITE_COLOR,
                                                      size: 5.w,
                                                    );
                                                  }
                                                }),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 0.7.h),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ///Type
                                              Flexible(
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(right: 1.w),
                                                          child: Icon(
                                                            Icons.calculate_sharp,
                                                            color: AppColors.SECONDARY_COLOR,
                                                            size: 4.5.w,
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: data.cashType ?? "",
                                                        style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 2.w),

                                              ///Mode
                                              Flexible(
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(right: 1.w),
                                                          child: Icon(
                                                            Icons.payments_rounded,
                                                            color: AppColors.SECONDARY_COLOR,
                                                            size: 4.5.w,
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: data.modeOfPayment ?? "",
                                                        style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 0.7.h),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ///Created By
                                              Flexible(
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(right: 1.w),
                                                          child: Icon(
                                                            Icons.person_2_rounded,
                                                            color: AppColors.SECONDARY_COLOR,
                                                            size: 4.5.w,
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: data.createdBy ?? "",
                                                        style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 2.w),

                                              ///Date
                                              Flexible(
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(right: 1.w),
                                                          child: Icon(
                                                            Icons.calendar_month_rounded,
                                                            color: AppColors.SECONDARY_COLOR,
                                                            size: 4.5.w,
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: DateFormat("dd/MM/yyyy, hh:mm a").format(DateTime.parse("${data.createdDate} ${data.createdTime}")),
                                                        style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (data.requestDeletion == true) ...[
                                            SizedBox(height: 1.h),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    AppStrings.wantsToDeleteThisEntry.tr.replaceAll("{ABC}", data.requestDeletionBy ?? "Someone"),
                                                    style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                  ),
                                                ),
                                                SizedBox(width: 2.w),

                                                ///Reject
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDeleteDialog(
                                                      ctx: context,
                                                      onPressed: () {
                                                        Get.back();
                                                        controller.acceptRejectDeleteCashFlowApiCall(
                                                          cashFlowId: data.cashFlowId ?? "",
                                                          isAccept: false,
                                                        );
                                                      },
                                                      agreeText: AppStrings.yesSure.tr,
                                                      title: AppStrings.areYouSureYouWantToRejectThisDeletionRequest.tr,
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
                                                  child: Obx(() {
                                                    if (controller.rejectDeletingId.value == data.cashFlowId) {
                                                      return SizedBox.square(
                                                        dimension: 3.5.w,
                                                        child: CircularProgressIndicator(
                                                          color: AppColors.PRIMARY_COLOR,
                                                          strokeWidth: 1.5,
                                                        ),
                                                      );
                                                    } else {
                                                      return Icon(
                                                        Icons.close_rounded,
                                                        color: AppColors.PRIMARY_COLOR,
                                                        size: 5.w,
                                                      );
                                                    }
                                                  }),
                                                ),
                                                SizedBox(width: 2.w),

                                                ///Accept
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDeleteDialog(
                                                      ctx: context,
                                                      onPressed: () {
                                                        Get.back();
                                                        controller.acceptRejectDeleteCashFlowApiCall(
                                                          cashFlowId: data.cashFlowId ?? "",
                                                          isAccept: true,
                                                        );
                                                      },
                                                      agreeText: AppStrings.yesSure.tr,
                                                      title: AppStrings.areYouSureYouWantToAcceptThisDeletionRequest.tr,
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.DARK_GREEN_COLOR,
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    padding: EdgeInsets.zero,
                                                    maximumSize: Size.square(8.w),
                                                    minimumSize: Size.square(8.w),
                                                    elevation: 4,
                                                  ),
                                                  child: Obx(() {
                                                    if (controller.acceptDeletingId.value == data.cashFlowId) {
                                                      return SizedBox.square(
                                                        dimension: 3.5.w,
                                                        child: CircularProgressIndicator(
                                                          color: AppColors.PRIMARY_COLOR,
                                                          strokeWidth: 1.5,
                                                        ),
                                                      );
                                                    } else {
                                                      return Icon(
                                                        Icons.check_rounded,
                                                        color: AppColors.PRIMARY_COLOR,
                                                        size: 5.w,
                                                      );
                                                    }
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                      tilePadding: EdgeInsets.only(left: 3.w, right: 1.5.w),
                                      enabled: false,
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
                                      childrenPadding: EdgeInsets.symmetric(horizontal: 2.w).copyWith(bottom: 2.h),
                                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
        ),
        SizedBox(height: 2.h),

        ///Add Cash Flow
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  showBottomSheetAddEditCashFlow(ctx: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.DARK_GREEN_COLOR,
                  elevation: 4,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  maximumSize: Size(43.w, 5.h),
                  minimumSize: Size(43.w, 5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppStrings.inFlow,
                  style: AppStyles.size16w600.copyWith(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: () {
                  showBottomSheetAddEditCashFlow(
                    ctx: context,
                    isOut: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.DARK_RED_COLOR,
                  elevation: 4,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  maximumSize: Size(43.w, 5.h),
                  minimumSize: Size(43.w, 5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppStrings.outFlow,
                  style: AppStyles.size16w600.copyWith(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
            colorScheme: ColorScheme.of(context).copyWith(
              primary: AppColors.TERTIARY_COLOR,
            ),
            datePickerTheme: DatePickerThemeData(
              rangeSelectionBackgroundColor: AppColors.TERTIARY_COLOR.withValues(alpha: 0.3),
            ),
          ),
          child: child!,
        );
      },
    );
    if (range != null) {
      controller.filterDateRange.value = range;
      return range;
    }
    return null;
  }

  Future<void> showBottomSheetAddEditCashFlow({
    required BuildContext ctx,
    String? cashFlowId,
    bool isOut = false,
  }) async {
    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        return AddEditCashFlowWidget(
          cashFlowId: cashFlowId,
          controller: controller,
          isOut: isOut,
        );
      },
    );
  }

  Future<void> showExportBottomSheet({
    required BuildContext ctx,
  }) async {
    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        return CashFlowPdfView(
          controller: controller,
        );
      },
    );
  }
}

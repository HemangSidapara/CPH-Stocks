import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/employee_models/get_reports_model.dart' as get_reports;
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/ledger_view.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/reports_screen/reports_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

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
                title: AppStrings.reports.tr,
                titleIcon: AppAssets.reportsIcon,
                titleIconSize: 10.w,
                onBackPressed: () {
                  Get.back(closeOverlays: true);
                },
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ///Date Interval
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Form(
                  key: controller.formKey,
                  child: Row(
                    children: [
                      ///Start Date
                      Flexible(
                        child: TextFieldWidget(
                          controller: controller.startDateController,
                          readOnly: true,
                          hintText: AppStrings.startDate.tr,
                          validator: controller.validateStartDate,
                          onTap: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: controller.startDateController.text.isNotEmpty ? DateFormat("yyyy-MM-dd").parse(controller.startDateController.text) : DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 50),
                              lastDate: controller.endDateController.text.isNotEmpty ? DateFormat("yyyy-MM-dd").parse(controller.endDateController.text) : DateTime(DateTime.now().year + 50),
                              builder: (context, child) {
                                return LedgerView().themeData(context: context, child: child!);
                              },
                            ).then((value) {
                              if (value != null) {
                                controller.startDateController.text = DateFormat("yyyy-MM-dd").format(value);
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 2.w),

                      ///End Date
                      Flexible(
                        child: TextFieldWidget(
                          controller: controller.endDateController,
                          readOnly: true,
                          hintText: AppStrings.endDate.tr,
                          validator: controller.validateEndDate,
                          onTap: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: controller.endDateController.text.isNotEmpty ? DateFormat("yyyy-MM-dd").parse(controller.endDateController.text) : DateTime.now(),
                              firstDate: controller.startDateController.text.isNotEmpty ? DateFormat("yyyy-MM-dd").parse(controller.startDateController.text) : DateTime(DateTime.now().year - 50),
                              lastDate: DateTime(DateTime.now().year + 50),
                              builder: (context, child) {
                                return LedgerView().themeData(context: context, child: child!);
                              },
                            ).then((value) {
                              if (value != null) {
                                controller.endDateController.text = DateFormat("yyyy-MM-dd").format(value);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              ///Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 0.7.h),
                child: Obx(() {
                  return ButtonWidget(
                    onPressed: () async {
                      try {
                        controller.isGeneratingReport(true);
                        await controller.getReportsApiCall(isRefresh: true);
                      } finally {
                        controller.isGeneratingReport(false);
                      }
                    },
                    isLoading: controller.isGeneratingReport.isTrue,
                    buttonTitle: AppStrings.generate.tr,
                  );
                }),
              ),
              DividerWidget(),

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
                    AppStrings.inch.tr,
                    style: TextStyle(
                      color: AppColors.WHITE_COLOR,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    AppStrings.amount.tr,
                    style: TextStyle(
                      color: AppColors.WHITE_COLOR,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              ///Tab View
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ///Inch Graph
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Obx(() {
                            if (controller.isLoading.isTrue) {
                              return LoadingWidget();
                            } else {
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  autoScrollingMode: AutoScrollingMode.start,
                                  autoScrollingDelta: 3,
                                  labelStyle: AppStyles.size14w600.copyWith(fontSize: 13.sp),
                                  multiLevelLabels: [
                                    ///No. of Employees
                                    for (int i = 0; i < controller.noOfEmployeeReportList.length; i++) ...[
                                      (() {
                                        final employeesData = controller.noOfEmployeeReportList[i];
                                        final dataInMonth = controller.inchReportList.where((p0) {
                                          final date = DateFormat("yyyy-MM-dd").parse(p0.date!);
                                          return date.year == employeesData.year?.toInt() && date.month == employeesData.month?.toInt();
                                        }).toList();
                                        final startDate = dataInMonth.firstOrNull?.date;
                                        final endDate = dataInMonth.lastOrNull?.date;
                                        return CategoricalMultiLevelLabel(
                                          start: startDate ?? "",
                                          end: endDate ?? "",
                                          text: employeesData.noOfEmployees?.toString() ?? "",
                                        );
                                      })(),
                                    ],
                                  ],
                                  multiLevelLabelStyle: MultiLevelLabelStyle(
                                    textStyle: AppStyles.size14w600,
                                    borderType: MultiLevelBorderType.curlyBrace,
                                  ),
                                ),
                                primaryYAxis: NumericAxis(
                                  labelStyle: AppStyles.size14w600.copyWith(fontSize: 13.sp),
                                ),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enableDoubleTapZooming: true,
                                  enablePanning: true,
                                  enablePinching: true,
                                ),
                                legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom,
                                  padding: 2.w,
                                  itemPadding: 5.h,
                                  textStyle: AppStyles.size15w600,
                                ),
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  builder: (data, point, series, pointIndex, seriesIndex) {
                                    return DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.WHITE_COLOR,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${AppStrings.date.tr}: ${controller.inchReportList[pointIndex].date != null ? DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(controller.inchReportList[pointIndex].date!)) : ""}",
                                              style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                            ),
                                            Text(
                                              "${AppStrings.inch.tr}: ${series.name == AppStrings.totalInch.replaceAll("C1 ", "") ? controller.inchReportList[pointIndex].totalInch : controller.inchReportList[pointIndex].completedInch}",
                                              style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                series: <CartesianSeries<get_reports.InchWiseReport, String>>[
                                  ///Total Inch Series
                                  ColumnSeries<get_reports.InchWiseReport, String>(
                                    dataSource: [...controller.inchReportList],
                                    xValueMapper: (get_reports.InchWiseReport data, _) => data.date != null ? DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(data.date!)) : "",
                                    yValueMapper: (get_reports.InchWiseReport data, _) => data.totalInch,
                                    enableTooltip: true,
                                    legendItemText: AppStrings.totalInch.tr.replaceAll("C1 ", ""),
                                    name: AppStrings.totalInch.replaceAll("C1 ", ""),
                                    color: AppColors.ORANGE_COLOR,
                                    animationDuration: 500,
                                  ),

                                  ///Completed Inch Series
                                  ColumnSeries<get_reports.InchWiseReport, String>(
                                    dataSource: [...controller.inchReportList],
                                    xValueMapper: (get_reports.InchWiseReport data, _) => data.date != null ? DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(data.date!)) : "",
                                    yValueMapper: (get_reports.InchWiseReport data, _) => data.completedInch,
                                    enableTooltip: true,
                                    legendItemText: AppStrings.completedInch.tr,
                                    name: AppStrings.completedInch,
                                    color: AppColors.DARK_GREEN_COLOR,
                                    animationDuration: 500,
                                  ),
                                ],
                              );
                            }
                          }),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Table(
                            border: TableBorder.all(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.PRIMARY_COLOR,
                              width: 1,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Text(
                                      AppStrings.totalInch.tr.replaceAll("C1 ", ""),
                                      style: AppStyles.size16w600,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Text(
                                      AppStrings.totalCompletedInch.tr,
                                      style: AppStyles.size16w600,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Obx(() {
                                      return Text(
                                        controller.totalInch.value.toString(),
                                        style: AppStyles.size16w600,
                                      );
                                    }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Obx(() {
                                      return Text(
                                        controller.totalCompletedInch.value.toString(),
                                        style: AppStyles.size16w600,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),

                    ///Amount Graph
                    Column(
                      children: [
                        Expanded(
                          child: Obx(() {
                            if (controller.isLoading.isTrue) {
                              return LoadingWidget();
                            } else {
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  autoScrollingMode: AutoScrollingMode.start,
                                  autoScrollingDelta: 3,
                                  labelStyle: AppStyles.size14w600.copyWith(fontSize: 13.sp),
                                  multiLevelLabels: [
                                    ///No. of Employees
                                    for (int i = 0; i < controller.noOfEmployeeReportList.length; i++) ...[
                                      (() {
                                        final employeesData = controller.noOfEmployeeReportList[i];
                                        final dataInMonth = controller.amountReportList.where((p0) {
                                          final date = DateFormat("yyyy-MM-dd").parse(p0.date!);
                                          return date.year == employeesData.year?.toInt() && date.month == employeesData.month?.toInt();
                                        }).toList();
                                        final startDate = dataInMonth.firstOrNull?.date;
                                        final endDate = dataInMonth.lastOrNull?.date;
                                        return CategoricalMultiLevelLabel(
                                          start: startDate ?? "",
                                          end: endDate ?? "",
                                          text: employeesData.noOfEmployees?.toString() ?? "",
                                        );
                                      })(),
                                    ],
                                  ],
                                  multiLevelLabelStyle: MultiLevelLabelStyle(
                                    textStyle: AppStyles.size14w600,
                                    borderType: MultiLevelBorderType.curlyBrace,
                                  ),
                                ),
                                primaryYAxis: NumericAxis(
                                  labelStyle: AppStyles.size14w600.copyWith(fontSize: 13.sp),
                                ),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enableDoubleTapZooming: true,
                                  enablePanning: true,
                                  enablePinching: true,
                                ),
                                legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom,
                                  padding: 2.w,
                                  itemPadding: 5.h,
                                  textStyle: AppStyles.size15w600,
                                ),
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  builder: (data, point, series, pointIndex, seriesIndex) {
                                    return DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.WHITE_COLOR,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${AppStrings.date.tr}: ${controller.amountReportList[pointIndex].date != null ? DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(controller.amountReportList[pointIndex].date!)) : ""}",
                                              style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                            ),
                                            Text(
                                              "${AppStrings.amount.tr}: ${NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(series.name == AppStrings.totalAmount.replaceAll("C1 ", "") ? controller.amountReportList[pointIndex].totalAmount : controller.amountReportList[pointIndex].completedAmount)}",
                                              style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                series: <CartesianSeries<get_reports.AmountWiseReport, String>>[
                                  ///Total Amount Series
                                  ColumnSeries<get_reports.AmountWiseReport, String>(
                                    dataSource: [...controller.amountReportList],
                                    xValueMapper: (get_reports.AmountWiseReport data, _) => data.date != null ? DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(data.date!)) : "",
                                    yValueMapper: (get_reports.AmountWiseReport data, _) => data.totalAmount,
                                    enableTooltip: true,
                                    legendItemText: AppStrings.totalAmount.tr.replaceAll("C1 ", ""),
                                    name: AppStrings.totalAmount.replaceAll("C1 ", ""),
                                    color: AppColors.ORANGE_COLOR,
                                    animationDuration: 500,
                                  ),

                                  ///Completed Amount Series
                                  ColumnSeries<get_reports.AmountWiseReport, String>(
                                    dataSource: [...controller.amountReportList],
                                    xValueMapper: (get_reports.AmountWiseReport data, _) => data.date != null ? DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(data.date!)) : "",
                                    yValueMapper: (get_reports.AmountWiseReport data, _) => data.completedAmount,
                                    enableTooltip: true,
                                    legendItemText: AppStrings.completedAmount.tr,
                                    name: AppStrings.completedAmount,
                                    color: AppColors.DARK_GREEN_COLOR,
                                    animationDuration: 500,
                                  ),
                                ],
                              );
                            }
                          }),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Table(
                            border: TableBorder.all(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.PRIMARY_COLOR,
                              width: 1,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Text(
                                      AppStrings.totalAmount.tr.replaceAll("C1 ", ""),
                                      style: AppStyles.size16w600,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Text(
                                      AppStrings.totalCompletedAmount.tr,
                                      style: AppStyles.size16w600,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Obx(() {
                                      return Text(
                                        NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(controller.totalAmount.value),
                                        style: AppStyles.size16w600,
                                      );
                                    }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    child: Obx(() {
                                      return Text(
                                        NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(controller.totalCompletedAmount.value),
                                        style: AppStyles.size16w600,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

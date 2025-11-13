import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_controller.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MonthlyCashbookWidget extends StatefulWidget {
  final CashFlowController controller;

  const MonthlyCashbookWidget({
    super.key,
    required this.controller,
  });

  @override
  State<MonthlyCashbookWidget> createState() => _MonthlyCashbookWidgetState();
}

class _MonthlyCashbookWidgetState extends State<MonthlyCashbookWidget> {
  RxBool isLoading = false.obs;

  Rx<DateTimeRange<DateTime>?> filterDateRange = Rx(null);
  Rx<DateTimeRange<DateTime>?> exportDateRange = Rx(null);

  @override
  void initState() {
    super.initState();
    filterDateRange.value = widget.controller.filterDateRange.value?.start != null && widget.controller.filterDateRange.value?.end != null
        ? DateTimeRange<DateTime>(
            start: widget.controller.filterDateRange.value!.start,
            end: widget.controller.filterDateRange.value!.end,
          )
        : null;
  }

  List<Map<String, dynamic>> generateMonthlyCycles() {
    final List<Map<String, dynamic>> cycles = [];

    DateTime start = DateTime(2025, 10, 11); // fixed starting cycle
    DateTime now = DateTime.now();

    while (start.isBefore(now)) {
      DateTime end;

      if (start.month == 12) {
        end = DateTime(start.year + 1, 1, 10);
      } else {
        end = DateTime(start.year, start.month + 1, 10);
      }

      cycles.add({
        "year": start.year,
        "month": start.month,
        "start": start,
        "end": end,
      });

      // move to next cycle → 11 next month
      if (start.month == 12) {
        start = DateTime(start.year + 1, 1, 11);
      } else {
        start = DateTime(start.year, start.month + 1, 11);
      }
    }

    return cycles;
  }

  Map<int, List<Map<String, dynamic>>> groupCyclesByYear(List<Map<String, dynamic>> cycles) {
    final Map<int, List<Map<String, dynamic>>> grouped = {};

    for (var c in cycles) {
      grouped.putIfAbsent(c["year"], () => []);
      grouped[c["year"]]!.add(c);
    }

    return grouped;
  }

  List<int> sortYearsDesc(Map<int, List<Map<String, dynamic>>> map) {
    final years = map.keys.toList();
    years.sort((a, b) => b.compareTo(a)); // DESC
    return years;
  }

  List<Map<String, dynamic>> sortYearCyclesDesc(List<Map<String, dynamic>> list) {
    list.sort((a, b) => b["start"].compareTo(a["start"])); // latest first
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Close, Title & Select
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CloseButtonWidget(),
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  AppStrings.monthlyCashbook.tr,
                  textAlign: TextAlign.center,
                  style: AppStyles.size18w600,
                ),
              ),
              SizedBox(width: 2.w),
              IconButton(
                onPressed: () async {
                  if (filterDateRange.value == null) {
                    return;
                  }
                  try {
                    isLoading(true);
                    widget.controller.filterDateRange.value = filterDateRange.value;
                    widget.controller.filterCashType.value = 0;
                    widget.controller.switchFilteredSummary(false);
                    await widget.controller.getCashFlowApiCall(isRefresh: true);
                    Get.back();
                  } finally {
                    isLoading(false);
                  }
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.DARK_GREEN_COLOR,
                  maximumSize: Size.square(8.w),
                  minimumSize: Size.square(8.w),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Obx(() {
                  if (isLoading.isTrue) {
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
        ),
        DividerWidget(),
        SizedBox(height: 2.h),

        Expanded(
          child: FutureBuilder(
            future: _buildCashbookData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: LoadingWidget(),
                );
              }

              final data = snapshot.data!;

              return ListView(
                children: data,
              );
            },
          ),
        ),
      ],
    );
  }

  Future<List<Widget>> _buildCashbookData() async {
    final cycles = generateMonthlyCycles();
    final grouped = groupCyclesByYear(cycles);
    final years = sortYearsDesc(grouped);

    final List<Widget> widgets = [];
    final currentYear = DateTime.now().year;

    for (var year in years) {
      final list = sortYearCyclesDesc(grouped[year]!);

      widgets.addAll(
        [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: ExpansionTile(
              initiallyExpanded: year == currentYear,
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
              dense: true,
              childrenPadding: EdgeInsets.only(bottom: 2.h),
              title: Text(
                "$year Cashbook",
                style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
              ),
              children: [
                DividerWidget(color: AppColors.SECONDARY_COLOR.withValues(alpha: 0.3)),
                ...list.map((c) => _buildCycleRow(c)),
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],
      );
    }

    return widgets;
  }

  Widget _buildCycleRow(Map<String, dynamic> c) {
    final start = c["start"];
    final end = c["end"];
    final month = c["month"];
    final year = c["year"];

    return GestureDetector(
      onTap: () {
        filterDateRange.value = DateTimeRange<DateTime>(
          start: start as DateTime,
          end: end as DateTime,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              return AnimatedContainer(
                duration: 375.milliseconds,
                decoration: BoxDecoration(
                  color: filterDateRange.value?.start.toString() == start.toString() && filterDateRange.value?.end.toString() == end.toString() ? AppColors.SECONDARY_COLOR : AppColors.TRANSPARENT,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(1.w),
                margin: EdgeInsets.only(right: 2.w),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                  size: filterDateRange.value?.start.toString() == start.toString() && filterDateRange.value?.end.toString() == end.toString() ? 4.5.w : 0,
                ),
              );
            }),
            Expanded(
              child: Text(
                "Cycle: $month-$year\n"
                "${start.day}-${start.month}-${start.year} → "
                "${end.day}-${end.month}-${end.year}",
                style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  exportDateRange.value = DateTimeRange<DateTime>(
                    start: start as DateTime,
                    end: end as DateTime,
                  );
                  final result = await widget.controller.getCashFlowExportApiCall(
                    dateRange: exportDateRange.value!,
                  );
                  if (!mounted) return;
                  widget.controller.showExportBottomSheet(
                    ctx: context,
                    allCashFlowList: result.$1,
                    cashCashFlowList: result.$2,
                    onlineCashFlowList: result.$3,
                    summary: result.$4,
                    cashSummary: result.$5,
                    onlineSummary: result.$6,
                  );
                } finally {
                  exportDateRange.value = null;
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: AppColors.ORANGE_COLOR,
                maximumSize: Size.square(8.w),
                minimumSize: Size.square(8.w),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Obx(() {
                if (exportDateRange.value?.start.toString() == start.toString() && exportDateRange.value?.end.toString() == end.toString()) {
                  return SizedBox.square(
                    dimension: 3.5.w,
                    child: CircularProgressIndicator(
                      color: AppColors.PRIMARY_COLOR,
                      strokeWidth: 1.5,
                    ),
                  );
                } else {
                  return FaIcon(
                    FontAwesomeIcons.solidFilePdf,
                    color: AppColors.PRIMARY_COLOR,
                    size: 4.w,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

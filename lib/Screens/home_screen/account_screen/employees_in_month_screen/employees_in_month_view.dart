import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/employees_in_month_screen/employees_in_month_controller.dart';
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
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmployeesInMonthView extends GetView<EmployeesInMonthController> {
  const EmployeesInMonthView({super.key});

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
                title: AppStrings.employeesInMonth.tr,
                titleIcon: AppAssets.employeeIcon,
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
                    AppStrings.employees.tr,
                    style: TextStyle(
                      color: AppColors.WHITE_COLOR,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    AppStrings.add.tr,
                    style: TextStyle(
                      color: AppColors.WHITE_COLOR,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              ///TabView
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    ///Employees
                    Column(
                      children: [
                        Expanded(
                          child: RefreshIndicatorWidget(
                            onRefresh: () async {
                              await controller.getNoOfEmployeesApiCall(isRefresh: true);
                            },
                            child: Obx(() {
                              if (controller.isLoading.isTrue) {
                                return Center(
                                  child: LoadingWidget(),
                                );
                              } else if (controller.employeesList.isEmpty) {
                                return NoDataFoundWidget(
                                  subtitle: AppStrings.noEmployeesDataFound.tr,
                                  onPressed: () {
                                    controller.getNoOfEmployeesApiCall(isRefresh: true);
                                  },
                                );
                              } else {
                                return AnimationLimiter(
                                  child: ListView.separated(
                                    itemCount: controller.employeesList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
                                    itemBuilder: (context, index) {
                                      final data = controller.employeesList[index];
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
                                                    ///Month & Year
                                                    Expanded(
                                                      child: Text(
                                                        "${data.month?.isNotEmpty == true ? controller.monthList[data.month!.toInt() - 1].tr : ""}, ${data.year ?? ""}".trim(),
                                                        style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                      ),
                                                    ),
                                                    SizedBox(width: 2.w),

                                                    ///No. of Employees
                                                    Tooltip(
                                                      message: AppStrings.noOfEmployees.tr,
                                                      child: Text(
                                                        data.noOfEmployees ?? "",
                                                        style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                                      ),
                                                    ),
                                                    SizedBox(width: 2.w),
                                                  ],
                                                ),
                                                enabled: false,
                                                tilePadding: EdgeInsets.only(left: 3.w, right: 2.w),
                                                trailing: ElevatedButton(
                                                  onPressed: () {
                                                    showBottomSheetEditNoOfEmployees(
                                                      ctx: context,
                                                      totalEmployeeId: data.totalEmployeeId ?? "",
                                                      noOfEmployees: data.noOfEmployees ?? "",
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
                                                    Icons.edit_rounded,
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

                    ///Add
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            ///Month
                            TextFieldWidget(
                              controller: controller.monthController,
                              readOnly: true,
                              title: AppStrings.month.tr,
                              hintText: AppStrings.selectMonth.tr,
                              validator: controller.validateMonth,
                              onTap: () {
                                CreateOrderView().showBottomSheetSelectAndAdd(
                                  ctx: context,
                                  selectOnly: true,
                                  items: controller.monthList,
                                  title: AppStrings.month.tr,
                                  fieldHint: "",
                                  searchHint: AppStrings.searchMonth.tr,
                                  selectedId: controller.selectedMonth.value,
                                  controller: controller.monthController,
                                  onSelect: (id) {
                                    controller.selectedMonth.value = id;
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 2.h),

                            ///Year
                            TextFieldWidget(
                              controller: controller.yearController,
                              readOnly: true,
                              title: AppStrings.year.tr,
                              hintText: AppStrings.selectYear.tr,
                              validator: controller.validateYear,
                              onTap: () {
                                CreateOrderView().showBottomSheetSelectAndAdd(
                                  ctx: context,
                                  selectOnly: true,
                                  items: controller.yearList,
                                  title: AppStrings.year.tr,
                                  fieldHint: "",
                                  searchHint: AppStrings.searchYear.tr,
                                  selectedId: controller.selectedYear.value,
                                  controller: controller.yearController,
                                  onSelect: (id) {
                                    controller.selectedYear.value = id;
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 2.h),

                            ///No. Of Employees
                            TextFieldWidget(
                              controller: controller.noOfEmployeesController,
                              title: AppStrings.noOfEmployees.tr,
                              hintText: AppStrings.enterNoOfEmployees.tr,
                              validator: controller.validateNoOfEmployees,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            Spacer(),

                            ///Button
                            Obx(() {
                              return ButtonWidget(
                                onPressed: () {
                                  Utils.unfocus();
                                  controller.addNoOfEmployeesApiCall();
                                },
                                isLoading: controller.isLoading.isTrue,
                                buttonTitle: AppStrings.add.tr,
                              );
                            }),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
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

  Future<void> showBottomSheetEditNoOfEmployees({
    required BuildContext ctx,
    required String totalEmployeeId,
    required String noOfEmployees,
  }) async {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController noOfEmployeesController = TextEditingController(text: noOfEmployees);

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
                            AppStrings.editNoOfEmployees.tr,
                            style: AppStyles.size18w600,
                          ),
                        ),
                        CloseButtonWidget(),
                      ],
                    ),
                  ),
                  DividerWidget(),
                  SizedBox(height: 2.h),

                  ///Fields
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Form(
                      key: formKey,
                      child: TextFieldWidget(
                        controller: noOfEmployeesController,
                        title: AppStrings.noOfEmployees.tr,
                        hintText: AppStrings.enterNoOfEmployees.tr,
                        validator: controller.validateNoOfEmployees,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
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
                              await controller.editNoOfEmployeesApiCall(
                                totalEmployeeId: totalEmployeeId,
                                noOfEmployees: noOfEmployeesController.text.trim(),
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
}

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/view_cycles_screen/view_cycles_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ViewCyclesView extends GetView<ViewCyclesController> {
  const ViewCyclesView({super.key});

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
                  title: AppStrings.viewCycles.tr,
                  titleIcon: AppAssets.viewCyclesIcon,
                  titleIconSize: 8.w,
                  onBackPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(height: 4.h),

                Expanded(
                  child: Obx(() {
                    if (controller.isGetOrderCycleLoading.isTrue) {
                      return const Center(
                        child: LoadingWidget(),
                      );
                    } else if (controller.orderCycleList.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.noDataFound.tr,
                          style: TextStyle(
                            color: AppColors.PRIMARY_COLOR,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: controller.orderCycleList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            color: AppColors.TRANSPARENT,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}. ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.SECONDARY_COLOR,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      controller.orderCycleList[index].createdDate != null || controller.orderCycleList[index].createdDate?.isNotEmpty == true ? DateFormat("MMMM dd, yyyy hh:mm a").format(DateTime.parse(controller.orderCycleList[index].createdDate!).toLocal()) : '',
                                      style: TextStyle(
                                        color: AppColors.SECONDARY_COLOR,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              dense: true,
                              collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                              backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                              iconColor: AppColors.SECONDARY_COLOR,
                              collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tilePadding: EdgeInsets.only(left: 3.w),
                              trailing: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppStrings.viewChallan.tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.DARK_RED_COLOR,
                                  ),
                                ),
                              ),
                              childrenPadding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
                              children: [
                                Divider(
                                  color: AppColors.HINT_GREY_COLOR,
                                  thickness: 1,
                                ),

                                ///OK Pcs
                                Row(
                                  children: [
                                    Text(
                                      "${AppStrings.okPcs.tr}: ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Text(
                                      controller.orderCycleList[index].okPcs ?? '',
                                      style: TextStyle(
                                        shadows: [
                                          Shadow(
                                            color: AppColors.PRIMARY_COLOR,
                                            blurRadius: 40,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.DARK_GREEN_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),

                                ///W/O Process
                                Row(
                                  children: [
                                    Text(
                                      "${AppStrings.woProcess.tr}: ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Text(
                                      controller.orderCycleList[index].woProcess ?? '',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.DARK_RED_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),

                                ///Pending
                                Row(
                                  children: [
                                    Text(
                                      "${AppStrings.pending.tr}: ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Text(
                                      controller.orderCycleList[index].pending ?? '',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.FACEBOOK_BLUE_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 2.h);
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

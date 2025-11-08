import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),

          ///Features
          Expanded(
            child: CustomScrollView(
              slivers: [
                ///Create Order
                if (getData(AppConstance.role) != AppConstance.customer) ...[
                  CommonButton(
                    route: Routes.createOrderScreen,
                    title: AppStrings.createOrder.tr,
                    icon: AppAssets.createOrderImage,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 2.h),
                  ),
                ],

                ///Order details
                CommonButton(
                  route: Routes.orderDetailsScreen,
                  title: AppStrings.orderDetails.tr,
                  icon: AppAssets.orderDetailsIcon,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 2.h),
                ),

                if (getData(AppConstance.role) != AppConstance.employee) ...[
                  ///Challan
                  CommonButton(
                    route: Routes.challanScreen,
                    title: AppStrings.challan.tr,
                    icon: AppAssets.challanIcon,
                  ),
                  if (getData(AppConstance.role) != AppConstance.customer) ...[
                    SliverToBoxAdapter(
                      child: SizedBox(height: 2.h),
                    ),
                  ],
                ],

                ///Repairing Details
                if (getData(AppConstance.role) != AppConstance.customer) ...[
                  CommonButton(
                    route: Routes.orderDetailsScreen,
                    isRepair: true,
                    title: AppStrings.repairingDetails.tr,
                    icon: AppAssets.repairingIcon,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 2.h),
                  ),
                ],

                ///Order Sequence
                if (![AppConstance.customer].contains(getData(AppConstance.role))) ...[
                  CommonButton(
                    route: Routes.orderSequenceScreen,
                    isRepair: true,
                    title: AppStrings.orderSequence.tr,
                    icon: AppAssets.orderSequenceIcon,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget CommonButton({
    required String route,
    required String title,
    required String icon,
    double? iconWidth,
    bool isRepair = false,
  }) {
    return SliverToBoxAdapter(
      child: ElevatedButton(
        onPressed: () async {
          Get.toNamed(route, arguments: isRepair);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.LIGHT_SECONDARY_COLOR,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 65.w,
                  child: Row(
                    children: [
                      Image.asset(
                        icon,
                        width: iconWidth ?? 18.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.SECONDARY_COLOR,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  AppAssets.frontIcon,
                  width: 9.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

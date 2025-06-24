import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/account_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Header
        Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomHeaderWidget(
                title: AppStrings.account.tr,
                titleIcon: AppAssets.accountAnim,
                titleIconSize: 10.5.w,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        ///Features
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomScrollView(
              slivers: [
                ///Ledger
                CommonButton(
                  route: Routes.ledgerScreen,
                  title: AppStrings.ledger.tr,
                  icon: AppAssets.ledgerIcon,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 2.h),
                ),

                ///Payment Ledger
                CommonButton(
                  route: Routes.paymentLedgerScreen,
                  title: AppStrings.paymentLedger.tr,
                  icon: AppAssets.ledgerIcon,
                  arguments: true,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 2.h),
                ),

                ///Payment Details
                CommonButton(
                  route: Routes.paymentDetailsScreen,
                  title: AppStrings.paymentDetails.tr,
                  icon: AppAssets.paymentDetailsIcon,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 2.h),
                ),

                ///Pending Payment
                CommonButton(
                  route: Routes.pendingPaymentScreen,
                  title: AppStrings.pendingPayment.tr,
                  icon: AppAssets.pendingPaymentIcon,
                ),

                if ([AppConstance.admin].contains(getData(AppConstance.role))) ...[
                  SliverToBoxAdapter(
                    child: SizedBox(height: 2.h),
                  ),

                  ///Reports
                  CommonButton(
                    route: Routes.reportsScreen,
                    title: AppStrings.reports.tr,
                    icon: AppAssets.reportsIcon,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 2.h),
                  ),

                  ///Employees in Month
                  CommonButton(
                    route: Routes.employeeInMonthScreen,
                    title: AppStrings.employeesInMonth.tr,
                    icon: AppAssets.employeeIcon,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 2.h),
                  ),

                  ///Categories
                  CommonButton(
                    route: Routes.categoriesScreen,
                    title: AppStrings.categories.tr,
                    icon: AppAssets.categoriesIcon,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 5.h),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget CommonButton({
    required String route,
    required String title,
    required String icon,
    double? iconWidth,
    dynamic arguments,
  }) {
    return SliverToBoxAdapter(
      child: ElevatedButton(
        onPressed: () async {
          Get.toNamed(route, arguments: arguments);
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
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: AppColors.SECONDARY_COLOR,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
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

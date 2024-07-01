import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/sort_by_pvd_color_screen/sort_by_pvd_color_view.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            child: Column(
              children: [
                ///Header
                Padding(
                  padding: EdgeInsets.only(left: 7.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomHeaderWidget(
                        title: AppStrings.orderDetails.tr,
                        titleIcon: AppAssets.orderDetailsIcon,
                        onBackPressed: () {
                          Get.back(closeOverlays: true);
                        },
                      ),
                      Obx(() {
                        return IconButton(
                          onPressed: controller.isRefreshing.value
                              ? () {}
                              : () async {
                                  await controller.getOrdersApi(isLoading: false);
                                },
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Obx(() {
                            return TweenAnimationBuilder(
                              duration: Duration(seconds: controller.isRefreshing.value ? 45 : 1),
                              tween: Tween(begin: 0.0, end: controller.isRefreshing.value ? 45.0 : controller.ceilValueForRefresh.value),
                              onEnd: () {
                                controller.isRefreshing.value = false;
                              },
                              builder: (context, value, child) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  controller.ceilValueForRefresh(value.toDouble().ceilToDouble());
                                });
                                return Transform.rotate(
                                  angle: value * 2 * 3.141592653589793,
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: AppColors.PRIMARY_COLOR,
                                    size: context.isPortrait ? 6.w : 6.h,
                                  ),
                                );
                              },
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                ///Sort by Color
                const Expanded(
                  child: SortByPvdColorView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

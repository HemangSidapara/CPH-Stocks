import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/sort_by_pvd_color_screen/sort_by_pvd_color_view.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: controller.isDeleteMultipleOrdersEnable.isFalse,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && controller.isDeleteMultipleOrdersEnable.isTrue && (controller.isDeletingMultipleOrders.isFalse || controller.isGenerateChallan.isFalse)) {
            controller.isDeleteMultipleOrdersEnable(false);
            controller.selectedOrderMetaIdForDeletion.clear();
            controller.selectedPartyForDeletingMultipleOrders.value == "";
          }
        },
        child: UnfocusWidget(
          child: Obx(() {
            return Scaffold(
              backgroundColor: AppColors.PRIMARY_COLOR.withValues(alpha: 0.5),
              appBar: AppBar(
                backgroundColor: controller.isDeleteMultipleOrdersEnable.isTrue ? AppColors.DARK_RED_COLOR : AppColors.TRANSPARENT,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                actionsPadding: EdgeInsets.zero,
                flexibleSpace: SafeArea(
                  child: controller.isDeleteMultipleOrdersEnable.isTrue
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 0.6.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.isDeleteMultipleOrdersEnable(false);
                                      controller.selectedOrderMetaIdForDeletion.clear();
                                      controller.selectedPartyForDeletingMultipleOrders.value == "";
                                    },
                                    style: IconButton.styleFrom(
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                    ),
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: AppColors.WHITE_COLOR,
                                      size: context.isPortrait ? 7.w : 7.h,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    AppStrings.selectOrders.tr,
                                    style: TextStyle(
                                      color: AppColors.WHITE_COLOR,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Obx(() {
                                return IconButton(
                                  onPressed: controller.isDeletingMultipleOrders.isFalse && controller.isGenerateChallan.isFalse
                                      ? () async {
                                          if (controller.selectedOrderMetaIdForDeletion.isNotEmpty) {
                                            try {
                                              controller.isDeletingMultipleOrders(true);
                                              await controller.showDeleteDialog(
                                                onPressed: () async {
                                                  await controller.deleteOrderApi(orderMetaId: controller.selectedOrderMetaIdForDeletion);
                                                },
                                                title: AppStrings.deleteItemText.tr,
                                              );
                                            } finally {
                                              controller.isDeleteMultipleOrdersEnable(false);
                                              controller.isDeletingMultipleOrders(false);
                                              controller.selectedOrderMetaIdForDeletion.clear();
                                              controller.selectedPartyForDeletingMultipleOrders.value == "";
                                            }
                                          } else {
                                            Utils.handleMessage(message: AppStrings.pleaseSelectAtLeastOneOrder.tr, isError: true);
                                          }
                                        }
                                      : () {},
                                  style: IconButton.styleFrom(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    padding: EdgeInsets.zero,
                                  ),
                                  icon: controller.isDeletingMultipleOrders.isTrue
                                      ? SizedBox(
                                          width: context.isPortrait ? 5.w : 5.h,
                                          height: context.isPortrait ? 5.w : 5.h,
                                          child: CircularProgressIndicator(
                                            color: AppColors.WHITE_COLOR,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Icon(
                                          Icons.delete_forever_rounded,
                                          color: AppColors.WHITE_COLOR,
                                          size: context.isPortrait ? 6.w : 6.h,
                                        ),
                                );
                              }),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() {
                                return CustomHeaderWidget(
                                  title: controller.isRepairScreen.isTrue ? AppStrings.repairingDetails.tr : AppStrings.orderDetails.tr,
                                  titleIcon: controller.isRepairScreen.isTrue ? AppAssets.repairingIcon : AppAssets.orderDetailsIcon,
                                  titleIconSize: controller.isRepairScreen.isTrue ? 9.w : null,
                                  titleColor: AppColors.SECONDARY_COLOR,
                                  onBackPressed: () {
                                    Get.back(closeOverlays: true);
                                  },
                                );
                              }),
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
                                            color: AppColors.SECONDARY_COLOR,
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
                ),
              ),
              bottomNavigationBar: controller.isDeleteMultipleOrdersEnable.isTrue
                  ? ColoredBox(
                      color: AppColors.DARK_GREEN_COLOR,
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.6.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.isDeleteMultipleOrdersEnable(false);
                                      controller.selectedOrderMetaIdForDeletion.clear();
                                      controller.selectedPartyForDeletingMultipleOrders.value == "";
                                    },
                                    style: IconButton.styleFrom(
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                    ),
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: AppColors.WHITE_COLOR,
                                      size: context.isPortrait ? 7.w : 7.h,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    AppStrings.generateChallan.tr,
                                    style: TextStyle(
                                      color: AppColors.WHITE_COLOR,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Obx(() {
                                return IconButton(
                                  onPressed: controller.isDeletingMultipleOrders.isFalse && controller.isGenerateChallan.isFalse
                                      ? () async {
                                          if (controller.selectedOrderMetaIdForDeletion.isNotEmpty) {
                                            try {
                                              controller.isGenerateChallan(true);
                                              await controller.showDeleteDialog(
                                                onPressed: () async {
                                                  await controller.generateInvoiceApi(orderMetaIds: controller.selectedOrderMetaIdForDeletion);
                                                },
                                                title: AppStrings.areYouSureYouWantToGenerateChallan.tr,
                                                iconData: Icons.receipt_long_rounded,
                                                iconColor: AppColors.DARK_GREEN_COLOR,
                                                agreeText: AppStrings.generate.tr,
                                              );
                                            } finally {
                                              controller.isDeleteMultipleOrdersEnable(false);
                                              controller.isGenerateChallan(false);
                                              controller.selectedOrderMetaIdForDeletion.clear();
                                              controller.selectedPartyForDeletingMultipleOrders.value == "";
                                            }
                                          } else {
                                            Utils.handleMessage(message: AppStrings.pleaseSelectAtLeastOneOrder.tr, isError: true);
                                          }
                                        }
                                      : () {},
                                  style: IconButton.styleFrom(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    padding: EdgeInsets.zero,
                                  ),
                                  icon: controller.isGenerateChallan.isTrue
                                      ? SizedBox(
                                          width: context.isPortrait ? 5.w : 5.h,
                                          height: context.isPortrait ? 5.w : 5.h,
                                          child: CircularProgressIndicator(
                                            color: AppColors.WHITE_COLOR,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Icon(
                                          Icons.receipt_rounded,
                                          color: AppColors.WHITE_COLOR,
                                          size: context.isPortrait ? 6.w : 6.h,
                                        ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Column(
                    children: [
                      ///Sort by Color
                      const Expanded(
                        child: SortByPvdColorView(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}

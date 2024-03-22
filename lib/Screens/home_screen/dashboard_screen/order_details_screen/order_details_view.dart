import 'dart:convert';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/item_id_model.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
            child: Column(
              children: [
                ///Header
                Row(
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
                SizedBox(height: 2.h),

                ///Searchbar
                TextFieldWidget(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.SECONDARY_COLOR,
                    size: 5.w,
                  ),
                  prefixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 8.w, minWidth: 8.w),
                  suffixIcon: InkWell(
                    onTap: () {
                      Utils.unfocus();
                      controller.searchController.clear();
                      controller.searchPartyName(controller.searchController.text);
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.SECONDARY_COLOR,
                      size: 5.w,
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 12.w, minWidth: 12.w),
                  hintText: AppStrings.searchParty.tr,
                  controller: controller.searchController,
                  onChanged: (value) {
                    controller.searchPartyName(value);
                  },
                ),
                SizedBox(height: 2.h),

                ///Order List
                Expanded(
                  child: Obx(() {
                    if (controller.isGetOrdersLoading.value) {
                      return const Center(
                        child: LoadingWidget(),
                      );
                    } else if (controller.searchedOrderList.isEmpty) {
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
                        itemCount: controller.searchedOrderList.length,
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
                                children: [
                                  Text(
                                    '${index + 1}. ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.SECONDARY_COLOR,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Flexible(
                                    child: Text(
                                      controller.searchedOrderList[index].partyName ?? '',
                                      style: TextStyle(
                                        color: AppColors.SECONDARY_COLOR,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              tilePadding: EdgeInsets.only(
                                left: 3.w,
                                right: 2.w,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///Edit
                                  IconButton(
                                    onPressed: () async {
                                      await showEditPartyBottomSheet(
                                        orderId: controller.searchedOrderList[index].orderId ?? '',
                                        partyName: controller.searchedOrderList[index].partyName ?? '',
                                        contactNumber: controller.searchedOrderList[index].contactNumber ?? '',
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.WARNING_COLOR,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                      elevation: 4,
                                      maximumSize: Size(7.5.w, 7.5.w),
                                      minimumSize: Size(7.5.w, 7.5.w),
                                    ),
                                    icon: Icon(
                                      Icons.edit_rounded,
                                      color: AppColors.PRIMARY_COLOR,
                                      size: 4.w,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),

                                  ///Delete
                                  IconButton(
                                    onPressed: () async {
                                      await showDeleteDialog(
                                        onPressed: () async {
                                          await controller.deletePartyApi(orderId: controller.searchedOrderList[index].orderId ?? '');
                                        },
                                        title: AppStrings.deletePartyText.tr.replaceAll("'Party'", "'${controller.searchedOrderList[index].partyName}'"),
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.DARK_RED_COLOR,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                      elevation: 4,
                                      maximumSize: Size(7.5.w, 7.5.w),
                                      minimumSize: Size(7.5.w, 7.5.w),
                                    ),
                                    icon: Icon(
                                      Icons.delete_forever_rounded,
                                      color: AppColors.PRIMARY_COLOR,
                                      size: 4.w,
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
                              childrenPadding: EdgeInsets.only(bottom: 2.h),
                              children: [
                                Divider(
                                  color: AppColors.HINT_GREY_COLOR,
                                  thickness: 1,
                                ),

                                ///Contact Number
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${AppStrings.contact.tr}: ",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.DARK_RED_COLOR,
                                        ),
                                      ),
                                      Text(
                                        "+91 ${controller.searchedOrderList[index].contactNumber ?? ''}",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.SECONDARY_COLOR,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                ///Headings
                                Divider(
                                  color: AppColors.HINT_GREY_COLOR,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.itemName.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 28.w,
                                        child: Text(
                                          AppStrings.pending.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: AppColors.HINT_GREY_COLOR,
                                  thickness: 1,
                                ),

                                ///Items
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 60.h),
                                  child: ListView.separated(
                                    itemCount: controller.searchedOrderList[index].modelMeta?.length ?? 0,
                                    shrinkWrap: true,
                                    itemBuilder: (context, itemIndex) {
                                      return ExpansionTile(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            /// ItemName
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '• ',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.SECONDARY_COLOR,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  Flexible(
                                                    child: Text(
                                                      controller.searchedOrderList[index].modelMeta?[itemIndex].itemName ?? '',
                                                      style: TextStyle(
                                                        color: AppColors.SECONDARY_COLOR,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            ///Pending
                                            SizedBox(
                                              width: 10.w,
                                              child: Text(
                                                controller.searchedOrderList[index].modelMeta?[itemIndex].pending ?? '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.sp,
                                                  color: AppColors.DARK_RED_COLOR,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ///Add Cycle
                                            IconButton(
                                              onPressed: () async {
                                                Get.toNamed(
                                                  Routes.addOrderCycleScreen,
                                                  arguments: ItemDetailsModel(
                                                    itemId: controller.searchedOrderList[index].modelMeta?[itemIndex].orderMetaId,
                                                    pending: controller.searchedOrderList[index].modelMeta?[itemIndex].pending?.toInt() ?? 0,
                                                  ),
                                                );
                                              },
                                              style: IconButton.styleFrom(
                                                backgroundColor: AppColors.FACEBOOK_BLUE_COLOR,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(180),
                                                ),
                                                padding: EdgeInsets.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                elevation: 4,
                                                maximumSize: Size(7.w, 7.w),
                                                minimumSize: Size(7.w, 7.w),
                                              ),
                                              icon: Icon(
                                                Icons.cyclone_rounded,
                                                color: AppColors.PRIMARY_COLOR,
                                                size: 4.w,
                                              ),
                                            ),
                                            SizedBox(width: 2.w),

                                            ///Delete
                                            IconButton(
                                              onPressed: () async {
                                                await showDeleteDialog(
                                                  onPressed: () async {
                                                    await controller.deleteOrderApi(orderMetaId: controller.searchedOrderList[index].modelMeta?[itemIndex].orderMetaId ?? '');
                                                  },
                                                  title: AppStrings.deleteItemText.tr.replaceAll("'Item'", "'${controller.searchedOrderList[index].partyName}'"),
                                                );
                                              },
                                              style: IconButton.styleFrom(
                                                backgroundColor: AppColors.DARK_RED_COLOR,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                padding: EdgeInsets.zero,
                                                elevation: 4,
                                                maximumSize: Size(7.5.w, 7.5.w),
                                                minimumSize: Size(7.5.w, 7.5.w),
                                              ),
                                              icon: Icon(
                                                Icons.delete_forever_rounded,
                                                color: AppColors.PRIMARY_COLOR,
                                                size: 4.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                        dense: true,
                                        collapsedShape: InputBorder.none,
                                        shape: InputBorder.none,
                                        collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                                        backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                                        iconColor: AppColors.SECONDARY_COLOR,
                                        tilePadding: EdgeInsets.only(left: 4.w, right: 2.w),
                                        childrenPadding: EdgeInsets.symmetric(horizontal: 3.w),
                                        children: [
                                          Divider(
                                            color: AppColors.HINT_GREY_COLOR,
                                            thickness: 1,
                                            height: 5,
                                          ),
                                          SizedBox(height: 0.5.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ///Details
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      ///Size
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${AppStrings.size.tr}: ",
                                                            style: TextStyle(
                                                              fontSize: 15.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: AppColors.SECONDARY_COLOR,
                                                            ),
                                                          ),
                                                          Text(
                                                            controller.searchedOrderList[index].modelMeta?[itemIndex].size ?? '',
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: AppColors.SECONDARY_COLOR,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0.5.h),

                                                      ///Quantity
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${AppStrings.quantity.tr}: ",
                                                            style: TextStyle(
                                                              fontSize: 15.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: AppColors.SECONDARY_COLOR,
                                                            ),
                                                          ),
                                                          Text(
                                                            controller.searchedOrderList[index].modelMeta?[itemIndex].quantity ?? '',
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: AppColors.SECONDARY_COLOR,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0.5.h),

                                                      ///PVD Color
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${AppStrings.pvdColor.tr}: ",
                                                            style: TextStyle(
                                                              fontSize: 15.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: AppColors.SECONDARY_COLOR,
                                                            ),
                                                          ),
                                                          Text(
                                                            controller.searchedOrderList[index].modelMeta?[itemIndex].pvdColor ?? '',
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: AppColors.SECONDARY_COLOR,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 1.h),

                                                      ///Last Cycle Data
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          AppStrings.lastCycleLog.tr,
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            color: AppColors.DARK_RED_COLOR,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 0.5.h),

                                                      ///Ok pcs.
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
                                                            controller.searchedOrderList[index].modelMeta?[itemIndex].okPcs ?? '',
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: AppColors.SECONDARY_COLOR,
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
                                                            controller.searchedOrderList[index].modelMeta?[itemIndex].woProcess ?? '',
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: AppColors.SECONDARY_COLOR,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0.5.h),

                                                      ///View Cycles
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Get.toNamed(
                                                            Routes.viewCyclesScreen,
                                                            arguments: ItemDetailsModel(
                                                              partyName: controller.searchedOrderList[index].partyName,
                                                              itemName: controller.searchedOrderList[index].modelMeta?[itemIndex].itemName,
                                                              itemId: controller.searchedOrderList[index].modelMeta?[itemIndex].orderMetaId,
                                                            ),
                                                          );
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: AppColors.SECONDARY_COLOR,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          elevation: 4,
                                                          fixedSize: Size(double.maxFinite, 4.5.h),
                                                        ),
                                                        child: Text(
                                                          AppStrings.viewCycles.tr,
                                                          style: TextStyle(
                                                            color: AppColors.PRIMARY_COLOR,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 26.h,
                                                  child: VerticalDivider(
                                                    color: AppColors.HINT_GREY_COLOR,
                                                    thickness: 1,
                                                  ),
                                                ),

                                                ///Item Image
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        AppStrings.itemImage.tr,
                                                        style: TextStyle(
                                                          color: AppColors.SECONDARY_COLOR,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 16.sp,
                                                        ),
                                                      ),
                                                      SizedBox(height: 1.h),
                                                      GestureDetector(
                                                        onLongPress: () async {
                                                          await showItemImageDialog(
                                                            itemName: controller.searchedOrderList[index].modelMeta?[itemIndex].itemName ?? AppStrings.itemImage.tr,
                                                            itemImage: controller.searchedOrderList[index].modelMeta?[itemIndex].itemImage != null || controller.searchedOrderList[index].modelMeta?[itemIndex].itemImage?.isNotEmpty == true ? controller.searchedOrderList[index].modelMeta![itemIndex].itemImage! : '',
                                                          );
                                                        },
                                                        child: Image.memory(
                                                          controller.searchedOrderList[index].modelMeta?[itemIndex].itemImage != null || controller.searchedOrderList[index].modelMeta?[itemIndex].itemImage?.isNotEmpty == true ? base64Decode(controller.searchedOrderList[index].modelMeta![itemIndex].itemImage!) : Uint8List(0),
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return SizedBox(
                                                              height: 15.h,
                                                              width: double.maxFinite,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.error_rounded,
                                                                    size: 6.w,
                                                                    color: AppColors.ERROR_COLOR,
                                                                  ),
                                                                  Text(
                                                                    error.toString().replaceAll('Exception: ', ''),
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      color: AppColors.SECONDARY_COLOR,
                                                                      fontSize: 15.sp,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(height: 1.h),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return SizedBox(height: 1.5.h);
                                    },
                                  ),
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

  Future<void> showItemImageDialog({
    required String itemName,
    required String itemImage,
  }) async {
    final imageData = itemImage.isNotEmpty ? base64Decode(itemImage) : Uint8List(0);
    await showGeneralDialog(
      context: Get.context!,
      barrierDismissible: false,
      barrierColor: AppColors.SECONDARY_COLOR,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Material(
            color: AppColors.SECONDARY_COLOR,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
              child: Column(
                children: [
                  ///ItemName
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            itemName,
                            style: TextStyle(
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.PRIMARY_COLOR,
                            size: 7.w,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Item Image
                  Center(
                    child: SizedBox(
                      height: 80.h,
                      child: Image.memory(
                        imageData,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            height: 15.h,
                            width: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_rounded,
                                  size: 6.w,
                                  color: AppColors.ERROR_COLOR,
                                ),
                                Text(
                                  error.toString().replaceAll('Exception: ', ''),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.SECONDARY_COLOR,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> showEditPartyBottomSheet({
    required String orderId,
    required String partyName,
    required String contactNumber,
  }) async {
    TextEditingController partyNameController = TextEditingController(text: partyName);
    TextEditingController contactNumberController = TextEditingController(text: contactNumber);
    await showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints(maxWidth: 100.w, minWidth: 100.w, maxHeight: 90.h, minHeight: 0.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.WHITE_COLOR,
      builder: (context) {
        final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
        return GestureDetector(
          onTap: () => Utils.unfocus(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h).copyWith(bottom: keyboardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Back & Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Title
                      Text(
                        AppStrings.editPartyDetails.tr,
                        style: TextStyle(
                          color: AppColors.SECONDARY_COLOR,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),

                      ///Back
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColors.SECONDARY_COLOR,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.HINT_GREY_COLOR,
                    thickness: 1,
                  ),
                  SizedBox(height: 2.h),

                  Form(
                    key: controller.editPartyFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///Party Name
                        TextFieldWidget(
                          controller: partyNameController,
                          title: AppStrings.partyName.tr,
                          hintText: AppStrings.enterPartyName,
                          validator: controller.validatePartyName,
                          textInputAction: TextInputAction.next,
                          maxLength: 30,
                          primaryColor: AppColors.SECONDARY_COLOR,
                          secondaryColor: AppColors.PRIMARY_COLOR,
                        ),
                        SizedBox(height: 1.h),

                        ///Contact Number
                        TextFieldWidget(
                          controller: contactNumberController,
                          title: AppStrings.contactNumber,
                          hintText: AppStrings.enterContactNumber,
                          validator: controller.validateContactNumber,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if (!newValue.text.isNumericOnly && newValue.text.isNotEmpty) {
                                return oldValue;
                              } else {
                                return newValue;
                              }
                            })
                          ],
                          maxLength: 10,
                          primaryColor: AppColors.SECONDARY_COLOR,
                          secondaryColor: AppColors.PRIMARY_COLOR,
                        ),
                        SizedBox(height: 3.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ///Cancel
                            ElevatedButton(
                              onPressed: () async {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.DARK_RED_COLOR,
                                fixedSize: Size(35.w, 5.h),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                AppStrings.cancel.tr,
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),

                            ///Update
                            ElevatedButton(
                              onPressed: () async {
                                Utils.unfocus();
                                await controller.updatePartyApi(
                                  orderId: orderId,
                                  partyName: partyNameController.text.trim(),
                                  contactNumber: contactNumberController.text.trim(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.DARK_GREEN_COLOR,
                                fixedSize: Size(35.w, 5.h),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                AppStrings.edit.tr,
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeleteDialog({
    required void Function()? onPressed,
    required String title,
  }) async {
    await showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: 'string',
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.WHITE_COLOR,
          surfaceTintColor: AppColors.WHITE_COLOR,
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.WHITE_COLOR,
            ),
            width: 80.w,
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.DARK_RED_COLOR,
                  size: 8.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Cancel
                      ButtonWidget(
                        onPressed: () {
                          Get.back();
                        },
                        fixedSize: Size(30.w, 5.h),
                        buttonTitle: AppStrings.cancel.tr,
                        buttonColor: AppColors.DARK_GREEN_COLOR,
                        buttonTitleColor: AppColors.PRIMARY_COLOR,
                      ),

                      ///Delete
                      ButtonWidget(
                        onPressed: onPressed,
                        fixedSize: Size(30.w, 5.h),
                        buttonTitle: AppStrings.delete.tr,
                        buttonColor: AppColors.DARK_RED_COLOR,
                        buttonTitleColor: AppColors.PRIMARY_COLOR,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/item_id_model.dart';
import 'package:cph_stocks/Network/models/order_models/pending_data_model.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
            child: Column(
              children: [
                ///Header
                CustomHeaderWidget(
                  title: AppStrings.orderDetails.tr,
                  titleIcon: AppAssets.orderDetailsIcon,
                  onBackPressed: () {
                    Get.back();
                  },
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

                                ///Headings
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
                                        width: 24.w,
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
                                              width: 15.w,
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
                                        trailing: IconButton(
                                          onPressed: () async {
                                            Get.toNamed(
                                              Routes.addOrderCycleScreen,
                                              arguments: PendingDataModel(
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
                                            Icons.edit_rounded,
                                            color: AppColors.PRIMARY_COLOR,
                                            size: 4.w,
                                          ),
                                        ),
                                        dense: true,
                                        collapsedShape: InputBorder.none,
                                        shape: InputBorder.none,
                                        collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                                        backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                                        iconColor: AppColors.SECONDARY_COLOR,
                                        tilePadding: EdgeInsets.only(left: 4.w, right: 3.w),
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
                                                            arguments: ItemIdModel(itemId: controller.searchedOrderList[index].modelMeta?[itemIndex].orderMetaId),
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
                                                      Image.memory(
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
}

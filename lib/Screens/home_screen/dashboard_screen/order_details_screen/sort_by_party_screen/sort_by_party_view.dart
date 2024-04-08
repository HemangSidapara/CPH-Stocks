import 'package:cached_network_image/cached_network_image.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/item_id_model.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SortByPartyView extends GetView<OrderDetailsController> {
  const SortByPartyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: Column(
        children: [
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
                controller.searchPartyController.clear();
                controller.searchPartyName(controller.searchPartyController.text);
              },
              child: Icon(
                Icons.close_rounded,
                color: AppColors.SECONDARY_COLOR,
                size: 5.w,
              ),
            ),
            suffixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 12.w, minWidth: 12.w),
            hintText: AppStrings.searchParty.tr,
            controller: controller.searchPartyController,
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
              } else if (controller.searchedPartyDataList.isEmpty) {
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
                  itemCount: controller.searchedPartyDataList.length,
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
                                controller.searchedPartyDataList[index].partyName ?? '',
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
                                  orderId: controller.searchedPartyDataList[index].orderId ?? '',
                                  partyName: controller.searchedPartyDataList[index].partyName ?? '',
                                  contactNumber: controller.searchedPartyDataList[index].contactNumber ?? '',
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
                                await controller.showDeleteDialog(
                                  onPressed: () async {
                                    await controller.deletePartyApi(orderId: controller.searchedPartyDataList[index].orderId ?? '');
                                  },
                                  title: AppStrings.deletePartyText.tr.replaceAll("'Party'", "'${controller.searchedPartyDataList[index].partyName}'"),
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
                                  "+91 ${controller.searchedPartyDataList[index].contactNumber ?? ''}",
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
                              itemCount: controller.searchedPartyDataList[index].modelMeta?.length ?? 0,
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
                                                controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemName ?? '',
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
                                          controller.searchedPartyDataList[index].modelMeta?[itemIndex].pending ?? '',
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
                                              itemId: controller.searchedPartyDataList[index].modelMeta?[itemIndex].orderMetaId,
                                              pending: controller.searchedPartyDataList[index].modelMeta?[itemIndex].pending?.toString().toInt() ?? 0,
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
                                          await controller.showDeleteDialog(
                                            onPressed: () async {
                                              await controller.deleteOrderApi(orderMetaId: controller.searchedPartyDataList[index].modelMeta?[itemIndex].orderMetaId ?? '');
                                            },
                                            title: AppStrings.deleteItemText.tr.replaceAll("'Item'", "'${controller.searchedPartyDataList[index].partyName}'"),
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
                                                ///Date
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "${AppStrings.orderDate.tr}: ",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.SECONDARY_COLOR,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    controller.searchedPartyDataList[index].modelMeta?[itemIndex].createdDate ?? '',
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.LIGHT_BLUE_COLOR,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 0.5.h),

                                                ///Size
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${AppStrings.size.tr}: ",
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.SECONDARY_COLOR,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        controller.searchedPartyDataList[index].modelMeta?[itemIndex].size ?? '',
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w700,
                                                          color: AppColors.SECONDARY_COLOR,
                                                        ),
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
                                                      controller.searchedPartyDataList[index].modelMeta?[itemIndex].quantity ?? '',
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${AppStrings.pvdColor.tr}: ",
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.SECONDARY_COLOR,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        controller.searchedPartyDataList[index].modelMeta?[itemIndex].pvdColor ?? '',
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w700,
                                                          color: AppColors.SECONDARY_COLOR,
                                                        ),
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
                                                      controller.searchedPartyDataList[index].modelMeta?[itemIndex].okPcs ?? '',
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
                                                      controller.searchedPartyDataList[index].modelMeta?[itemIndex].woProcess ?? '',
                                                      style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w700,
                                                        color: AppColors.SECONDARY_COLOR,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 0.5.h),

                                                ///Actions
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    ///View Cycles
                                                    IconButton(
                                                      onPressed: () {
                                                        Get.toNamed(
                                                          Routes.viewCyclesScreen,
                                                          arguments: ItemDetailsModel(
                                                            partyName: controller.searchedPartyDataList[index].partyName,
                                                            itemName: controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemName,
                                                            itemId: controller.searchedPartyDataList[index].modelMeta?[itemIndex].orderMetaId,
                                                          ),
                                                        );
                                                      },
                                                      style: IconButton.styleFrom(
                                                        backgroundColor: AppColors.SECONDARY_COLOR,
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      icon: Icon(
                                                        Icons.remove_red_eye_rounded,
                                                        color: AppColors.PRIMARY_COLOR,
                                                      ),
                                                    ),

                                                    ///Edit Item
                                                    IconButton(
                                                      onPressed: () async {
                                                        await controller.showEditItemBottomSheet(
                                                          orderMetaId: controller.searchedPartyDataList[index].modelMeta?[itemIndex].orderMetaId ?? '',
                                                          itemName: controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemName ?? '',
                                                          itemImage: controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemImage ?? '',
                                                        );
                                                      },
                                                      style: IconButton.styleFrom(
                                                        backgroundColor: AppColors.WARNING_COLOR,
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      icon: Icon(
                                                        Icons.edit_rounded,
                                                        color: AppColors.PRIMARY_COLOR,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 1.h),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 27.h,
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
                                                    await controller.showItemImageDialog(
                                                      itemName: controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemName ?? AppStrings.itemImage.tr,
                                                      itemImage: controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemImage != null || controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemImage?.isNotEmpty == true ? controller.searchedPartyDataList[index].modelMeta![itemIndex].itemImage! : '',
                                                    );
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl: controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemImage ?? '',
                                                    fit: BoxFit.contain,
                                                    cacheKey: controller.searchedPartyDataList[index].modelMeta?[itemIndex].itemImage,
                                                    progressIndicatorBuilder: (context, url, progress) {
                                                      return SizedBox(
                                                        height: 15.h,
                                                        width: double.maxFinite,
                                                        child: Column(
                                                          children: [
                                                            CircularProgressIndicator(
                                                              color: AppColors.SECONDARY_COLOR,
                                                              value: progress.progress,
                                                              strokeWidth: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    errorWidget: (context, error, stackTrace) {
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
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/get_orders_model.dart';
import 'package:cph_stocks/Network/models/order_models/item_id_model.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SortByPvdColorView extends GetView<OrderDetailsController> {
  const SortByPvdColorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Searchbar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          child: TextFieldWidget(
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
              controller.searchedColorDataList.refresh();
            },
          ),
        ),
        SizedBox(height: 2.h),

        Obx(() {
          if (controller.isGetOrdersLoading.value) {
            return const Expanded(
              child: Center(
                child: LoadingWidget(),
              ),
            );
          } else if (controller.searchedColorDataList.isEmpty) {
            return Expanded(
              child: Center(
                child: Text(
                  AppStrings.noDataFound.tr,
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          } else {
            return Expanded(
              child: Column(
                children: [
                  TabBar(
                    controller: controller.sortByColorTabController,
                    isScrollable: true,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    tabAlignment: TabAlignment.center,
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ).copyWith(top: 0),
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
                      controller.selectedSortByColorTabIndex(value);
                    },
                    tabs: [
                      for (int i = 0; i < controller.searchedColorDataList.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ///Color Name
                            Flexible(
                              child: Text(
                                controller.searchedColorDataList[i].pvdColor ?? '',
                                style: TextStyle(
                                  color: AppColors.WHITE_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),

                            ///Color
                            SizedBox(
                              height: 4.w,
                              width: 4.w,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: controller.colorCodes.containsKey(controller.searchedColorDataList[i].pvdColor) == true ? controller.colorCodes[controller.searchedColorDataList[i].pvdColor] : AppColors.SECONDARY_COLOR,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.PRIMARY_COLOR,
                                    width: 0.7,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  ///Party Data
                  Expanded(
                    child: TabBarView(
                      controller: controller.sortByColorTabController,
                      children: [
                        for (int j = 0; j < controller.searchedColorDataList.length; j++) ColorDataWidget(index: j),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ],
    );
  }

  ///PartyData
  // ignore: non_constant_identifier_names
  Widget ColorDataWidget({required int index}) {
    return Column(
      children: [
        Flexible(
          child: AnimationLimiter(
            child: ListView.separated(
              itemCount: controller.searchedColorDataList[index].partyMeta?.length ?? 0,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
              itemBuilder: (context, partyIndex) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Card(
                        color: AppColors.TRANSPARENT,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Text(
                                '${partyIndex + 1}. ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Flexible(
                                child: Text(
                                  controller.searchedColorDataList[index].partyMeta?[partyIndex].partyName ?? '',
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
                                    orderId: controller.searchedColorDataList[index].partyMeta?[partyIndex].orderId ?? '',
                                    partyName: controller.searchedColorDataList[index].partyMeta?[partyIndex].partyName ?? '',
                                    contactNumber: controller.searchedColorDataList[index].partyMeta?[partyIndex].contactNumber ?? '',
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
                                      await controller.deletePartyApi(orderId: controller.searchedColorDataList[index].partyMeta?[partyIndex].orderId ?? '');
                                    },
                                    title: AppStrings.deletePartyText.tr.replaceAll("'Party'", "'${controller.searchedColorDataList[index].partyMeta?[partyIndex].partyName}'"),
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
                                    "+91 ${controller.searchedColorDataList[index].partyMeta?[partyIndex].contactNumber ?? ''}",
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
                                    width: 32.5.w,
                                    child: Row(
                                      children: [
                                        Text(
                                          AppStrings.quantity.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          AppStrings.pending.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
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
                            for (int dateIndex = 0; dateIndex < (controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?.length ?? 0); dateIndex++) ...[
                              ///DateTime
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 2.w),
                                            child: FaIcon(
                                              FontAwesomeIcons.clock,
                                              size: 4.w,
                                              color: AppColors.SECONDARY_COLOR,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].createdDate != null && controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].createdTime != null
                                              ? DateFormat("yyyy-MM-dd, hh:mm a").format(DateTime.parse("${controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].createdDate}T${controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].createdTime}"))
                                              : "${controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].createdDate ?? ""}, ${controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].createdTime ?? ""}",
                                          style: TextStyle(
                                            color: AppColors.DARK_RED_COLOR,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            shadows: [
                                              Shadow(
                                                color: AppColors.PRIMARY_COLOR,
                                                offset: const Offset(2, 2),
                                                blurRadius: 40,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: AppColors.HINT_GREY_COLOR,
                                thickness: 1,
                              ),

                              ///Description
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Text.rich(
                                    TextSpan(
                                      text: "${AppStrings.description.tr}: ",
                                      children: [
                                        TextSpan(
                                          text: controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].description ?? "",
                                          style: TextStyle(
                                            color: AppColors.SECONDARY_COLOR,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),

                              AnimationLimiter(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: AnimationConfiguration.toStaggeredList(
                                    duration: const Duration(milliseconds: 375),
                                    childAnimationBuilder: (child) => SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(child: child),
                                    ),
                                    children: [
                                      for (int orderIndex = 0; orderIndex < (controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?.length ?? 0); orderIndex++) ...[
                                        GestureDetector(
                                          onTap: () async {
                                            await showItemDetailsBottomSheet(
                                              partyName: controller.searchedColorDataList[index].partyMeta?[partyIndex].partyName ?? '',
                                              itemDetails: controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?[orderIndex],
                                            );
                                          },
                                          child: ExpansionTile(
                                            enabled: false,
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
                                                          [controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?[orderIndex].itemName ?? '', controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?[orderIndex].size ?? ''].join(' | '),
                                                          style: TextStyle(
                                                            color: AppColors.SECONDARY_COLOR,
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2.w),
                                                    ],
                                                  ),
                                                ),

                                                ///Quantity & Pending
                                                Row(
                                                  children: [
                                                    Text(
                                                      controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?[orderIndex].quantity ?? '',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 16.sp,
                                                        color: AppColors.LIGHT_BLUE_COLOR,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3.h,
                                                      child: VerticalDivider(
                                                        color: AppColors.SECONDARY_COLOR,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                    Text(
                                                      controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?[orderIndex].pending ?? '',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 16.sp,
                                                        color: AppColors.DARK_RED_COLOR,
                                                      ),
                                                    ),
                                                  ],
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
                                                        itemId: controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?[orderIndex].orderMetaId,
                                                        pending: controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?[orderIndex].pending?.toString().toInt() ?? 0,
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
                                                        await controller.deleteOrderApi(orderMetaId: controller.searchedColorDataList[index].partyMeta?[partyIndex].orderDate?[dateIndex].modelMeta?[orderIndex].orderMetaId ?? '');
                                                      },
                                                      title: AppStrings.deleteItemText.tr.replaceAll("'Item'", "'${controller.searchedColorDataList[index].partyMeta?[partyIndex].partyName}'"),
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
                                          ),
                                        ),
                                        SizedBox(height: 1.5.h),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 1.h);
              },
            ),
          ),
        ),
      ],
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

  Future<void> showItemDetailsBottomSheet({
    required String partyName,
    required ModelMeta? itemDetails,
  }) async {
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
                        AppStrings.itemDetails.tr,
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

                  ///Item Name & Order Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          itemDetails?.itemName ?? '',
                          style: TextStyle(
                            color: AppColors.SECONDARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Row(
                        children: [
                          Text(
                            "${AppStrings.orderDate.tr}: ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.SECONDARY_COLOR,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            itemDetails?.createdDate ?? '',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.LIGHT_BLUE_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  ///Size, Quantity & PVD Color
                  Table(
                    border: TableBorder.all(
                      color: AppColors.SECONDARY_COLOR,
                      width: 0.8,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                AppStrings.size.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                AppStrings.quantity.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                AppStrings.pvdColor.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                              child: Text(
                                itemDetails?.size ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.LIGHT_BLUE_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                              child: Text(
                                itemDetails?.quantity ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.LIGHT_BLUE_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                              child: Text(
                                itemDetails?.pvdColor ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.LIGHT_BLUE_COLOR,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  ///Total Stats Log:
                  Text(
                    "✤ ${AppStrings.totalStatsLog.tr.replaceAll(':', '')} ✤",
                    style: TextStyle(
                      color: AppColors.DARK_RED_COLOR,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  ///Ok pcs., Pending & W/O Process
                  Table(
                    border: TableBorder.all(
                      color: AppColors.SECONDARY_COLOR,
                      width: 0.8,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                AppStrings.okPcs.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                AppStrings.pending.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                AppStrings.woProcess.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                              child: Text(
                                itemDetails?.okPcs ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.LIGHT_BLUE_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                              child: Text(
                                itemDetails?.pending ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ORANGE_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                              child: Text(
                                itemDetails?.woProcess ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.LIGHT_BLUE_COLOR,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  ///Item Image
                  Text(
                    "✤ ${AppStrings.itemImage.tr} ✤",
                    style: TextStyle(
                      color: AppColors.DARK_RED_COLOR,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Flexible(
                    child: GestureDetector(
                      onTap: () async {
                        await controller.showItemImageDialog(
                          itemName: itemDetails?.itemName ?? AppStrings.itemImage.tr,
                          itemImage: itemDetails?.itemImage != null || itemDetails?.itemImage?.isNotEmpty == true ? (itemDetails?.itemImage ?? '') : '',
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: itemDetails?.itemImage ?? '',
                        cacheKey: itemDetails?.itemImage,
                        progressIndicatorBuilder: (context, url, progress) {
                          return SizedBox(
                            height: 15.h,
                            width: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                  SizedBox(height: 2.h),

                  ///Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ///View Cycles
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed(
                            Routes.viewCyclesScreen,
                            arguments: ItemDetailsModel(
                              partyName: partyName,
                              itemName: itemDetails?.itemName,
                              itemId: itemDetails?.orderMetaId,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.SECONDARY_COLOR,
                          elevation: 4,
                          fixedSize: Size(38.w, 5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Icon(
                          Icons.remove_red_eye_rounded,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),

                      ///Edit Item
                      ElevatedButton(
                        onPressed: itemDetails?.quantity == itemDetails?.pending
                            ? () async {
                                Get.back();
                                await controller.showEditItemBottomSheet(
                                  orderMetaId: itemDetails?.orderMetaId ?? "",
                                  itemName: itemDetails?.itemName ?? "",
                                  pvdColor: itemDetails?.pvdColor ?? "",
                                  quantity: itemDetails?.quantity ?? "",
                                  size: itemDetails?.size ?? "",
                                  itemImage: itemDetails?.itemImage ?? '',
                                );
                              }
                            : () {
                                Utils.handleMessage(message: AppStrings.nowItemCantBeEditable.tr, isError: true);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.WARNING_COLOR,
                          elevation: 4,
                          fixedSize: Size(38.w, 5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/get_orders_model.dart' as get_orders;
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_sequence_screen/order_sequence_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/refresh_indicator_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderSequenceView extends GetView<OrderSequenceController> {
  const OrderSequenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        backgroundColor: AppColors.PRIMARY_COLOR.withValues(alpha: 0.5),
        appBar: AppBar(
          backgroundColor: AppColors.TRANSPARENT,
          leadingWidth: 0,
          leading: SizedBox.shrink(),
          actionsPadding: EdgeInsets.zero,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomHeaderWidget(
                    title: AppStrings.orderSequence.tr,
                    titleIcon: AppAssets.orderSequenceIcon,
                    titleIconSize: 8.5.w,
                    titleColor: AppColors.SECONDARY_COLOR,
                    onBackPressed: () {
                      Get.back(closeOverlays: true);
                    },
                  ),
                  Obx(() {
                    return IconButton(
                      onPressed: controller.isRefreshing.value
                          ? () {}
                          : () async {
                              await controller.getOrdersApi(isRefresh: true);
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Column(
              children: [
                ///Search Items
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: TextFieldWidget(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.PRIMARY_COLOR,
                      size: 5.w,
                    ),
                    primaryColor: AppColors.SECONDARY_COLOR,
                    secondaryColor: AppColors.PRIMARY_COLOR,
                    prefixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 8.w, minWidth: 8.w),
                    suffixIcon: InkWell(
                      onTap: () {
                        Utils.unfocus();
                        controller.searchItemNameController.clear();
                        controller.searchItemName(controller.searchItemNameController.text);
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.PRIMARY_COLOR,
                        size: 5.w,
                      ),
                    ),
                    suffixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 12.w, minWidth: 12.w),
                    hintText: AppStrings.searchItem.tr,
                    controller: controller.searchItemNameController,
                    onChanged: (value) {
                      controller.searchItemName(value);
                      controller.searchedColorDataList.refresh();
                    },
                  ),
                ),
                SizedBox(height: 2.h),

                ///Order Data
                Expanded(
                  child: Obx(() {
                    if (controller.isGetOrdersLoading.isTrue) {
                      return Center(
                        child: LoadingWidget(),
                      );
                    } else if (controller.searchedColorDataList.isEmpty) {
                      return NoDataFoundWidget(
                        subtitle: AppStrings.noDataFound.tr,
                        onPressed: () {
                          controller.getOrdersApi();
                        },
                      );
                    } else {
                      return Column(
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
                                          color: AppColors.SECONDARY_COLOR,
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
                                for (int j = 0; j < controller.searchedColorDataList.length; j++)
                                  RefreshIndicatorWidget(
                                    onRefresh: () async {
                                      await controller.getOrdersApi(isRefresh: true);
                                    },
                                    child: ColorDataWidget(index: j),
                                  ),
                              ],
                            ),
                          ),
                        ],
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

  ///Items Data
  Widget ColorDataWidget({required int index}) {
    return Column(
      children: [
        Flexible(
          child: AnimationLimiter(
            child: ListView.separated(
              itemCount: controller.searchedColorDataList[index].orders?.length ?? 0,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
              itemBuilder: (context, orderIndex) {
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
                          enabled: false,
                          title: Stack(
                            alignment: Alignment.center,
                            fit: StackFit.passthrough,
                            children: [
                              ///Party Name
                              Positioned(
                                right: 0,
                                left: 0,
                                top: 0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Tooltip(
                                        message: controller.searchedColorDataList[index].orders?[orderIndex].partyName ?? "",
                                        child: Text(
                                          controller.searchedColorDataList[index].orders?[orderIndex].partyName ?? "",
                                          style: AppStyles.size16w600.copyWith(color: controller.getTextColor(controller.searchedColorDataList[index].pvdColor ?? '').withValues(alpha: 0.06), fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ),

                                    Flexible(
                                      child: Tooltip(
                                        message: controller.searchedColorDataList[index].orders?[orderIndex].categoryName ?? "",
                                        child: Text(
                                          controller.searchedColorDataList[index].orders?[orderIndex].categoryName ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.size18w600.copyWith(color: controller.getTextColor(controller.searchedColorDataList[index].pvdColor ?? '').withValues(alpha: 0.06), fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              ///Item details
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ///Image, Item Name & Size
                                  Flexible(
                                    child: Row(
                                      children: [
                                        /// ItemImage
                                        InkWell(
                                          onTap: () async {
                                            final itemImage = controller.searchedColorDataList[index].orders?[orderIndex].itemImage;
                                            await controller.showItemImageDialog(
                                              itemName: controller.searchedColorDataList[index].orders?[orderIndex].itemName ?? AppStrings.itemImage.tr,
                                              itemImage: itemImage != null || itemImage?.isNotEmpty == true ? (itemImage ?? '') : '',
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 6.w,
                                            backgroundColor: AppColors.SECONDARY_COLOR,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(360),
                                              child: SizedBox(
                                                width: 12.w,
                                                height: 12.w,
                                                child: ColoredBox(
                                                  color: AppColors.SECONDARY_COLOR,
                                                  child: CachedNetworkImage(
                                                    imageUrl: controller.searchedColorDataList[index].orders?[orderIndex].itemImage ?? '',
                                                    cacheKey: controller.searchedColorDataList[index].orders?[orderIndex].itemImage,
                                                    errorWidget: (context, url, error) {
                                                      return Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Image.asset(
                                                            AppAssets.createOrderImage,
                                                            width: 10.w,
                                                            height: 10.w,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              /// ItemName
                                              Text(
                                                controller.searchedColorDataList[index].orders?[orderIndex].itemName ?? '',
                                                style: AppStyles.size16w600.copyWith(color: controller.getTextColor(controller.searchedColorDataList[index].orders?[orderIndex].pvdColor ?? '')),
                                              ),

                                              /// ItemSize
                                              Text(
                                                "${controller.searchedColorDataList[index].orders?[orderIndex].size ?? ''}\"",
                                                style: AppStyles.size16w600.copyWith(color: controller.getTextColor(controller.searchedColorDataList[index].orders?[orderIndex].pvdColor ?? '')),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 2.w),

                                  ///Quantity
                                  Tooltip(
                                    message: AppStrings.quantity.tr,
                                    child: Text(
                                      controller.searchedColorDataList[index].orders?[orderIndex].quantity ?? '',
                                      style: AppStyles.size16w600.copyWith(color: controller.getTextColor(controller.searchedColorDataList[index].orders?[orderIndex].pvdColor ?? '')),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          tilePadding: EdgeInsets.symmetric(horizontal: 3.w),
                          showTrailingIcon: false,
                          dense: true,
                          collapsedBackgroundColor: controller.backgroundColorCodes.containsKey(controller.searchedColorDataList[index].pvdColor) == true ? controller.backgroundColorCodes[controller.searchedColorDataList[index].pvdColor] : AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                          backgroundColor: controller.backgroundColorCodes.containsKey(controller.searchedColorDataList[index].pvdColor) == true ? controller.backgroundColorCodes[controller.searchedColorDataList[index].pvdColor] : AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
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
                          children: [],
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

  Future<void> showItemDetailsBottomSheet({
    required String partyName,
    required get_orders.ModelMeta? itemDetails,
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

                  ///Created By
                  SizedBox(height: 1.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        text: "${AppStrings.creator.tr}: ",
                        children: [
                          TextSpan(
                            text: itemDetails?.createdBy ?? '',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.DARK_GREEN_COLOR,
                            ),
                          ),
                        ],
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ),
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
                                "${itemDetails?.size ?? ''}\"",
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
                                  AppStrings.imageNotFound.tr,
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

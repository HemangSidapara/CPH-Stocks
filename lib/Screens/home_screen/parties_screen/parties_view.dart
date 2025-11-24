import 'dart:async';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/parties_screen/add_edit_party_widget.dart';
import 'package:cph_stocks/Screens/home_screen/parties_screen/parties_controller.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/refresh_indicator_widget.dart';
import 'package:cph_stocks/Widgets/show_delete_dialog_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PartiesView extends GetView<PartiesController> {
  const PartiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: SearchBar(
              controller: controller.searchController,
              hintText: AppStrings.searchParty.tr,
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              backgroundColor: WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),
              constraints: BoxConstraints.tight(Size(double.maxFinite, 5.h)),
              leading: Icon(
                Icons.search_rounded,
                size: 5.w,
                color: AppColors.SECONDARY_COLOR,
              ),
              trailing: [
                CloseButton(
                  onPressed: () {
                    Utils.unfocus();
                    controller.searchController.clear();
                    controller.getPartyApiCall(isRefresh: true);
                  },
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    iconSize: 5.w,
                    maximumSize: Size.square(8.w),
                    minimumSize: Size.square(8.w),
                  ),
                ),
              ],
              onChanged: (value) {
                if (controller.debounce?.isActive == true) controller.debounce?.cancel();
                controller.debounce = Timer(
                  375.milliseconds,
                  () {
                    controller.getPartyApiCall(isRefresh: true);
                  },
                );
              },
            ),
          ),

          Expanded(
            child: RefreshIndicatorWidget(
              onRefresh: () async {
                await controller.getPartyApiCall(isRefresh: true);
              },
              child: Obx(() {
                if (controller.isLoading.isTrue) {
                  return Center(
                    child: LoadingWidget(),
                  );
                } else if (controller.partyList.isEmpty) {
                  return NoDataFoundWidget(
                    subtitle: AppStrings.noDataFound.tr,
                  );
                } else {
                  return AnimationLimiter(
                    child: ListView.separated(
                      itemCount: controller.partyList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h).copyWith(bottom: 2.h),
                      itemBuilder: (context, index) {
                        final data = controller.partyList[index];
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
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data.partyName ?? "",
                                              style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                            ),
                                          ),
                                          SizedBox(width: 1.w),

                                          Text(
                                            data.paymentType ?? "",
                                            style: AppStyles.size14w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.call_rounded,
                                                color: AppColors.SECONDARY_COLOR,
                                                size: 4.w,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 1.w),
                                            ),
                                            TextSpan(
                                              text: data.contactNumber ?? "",
                                              style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                FontAwesomeIcons.coins,
                                                color: AppColors.SECONDARY_COLOR,
                                                size: 4.w,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 2.w),
                                            ),
                                            TextSpan(
                                              text: NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.pendingBalance ?? 0.0),
                                              style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  tilePadding: EdgeInsets.only(left: 3.w, right: 1.5.w),
                                  enabled: false,
                                  dense: true,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showBottomSheetAddEditParty(
                                            ctx: context,
                                            controller: controller,
                                            partyId: data.orderId ?? "",
                                          );
                                        },
                                        style: IconButton.styleFrom(
                                          backgroundColor: AppColors.WARNING_COLOR,
                                          maximumSize: Size.square(8.w),
                                          minimumSize: Size.square(8.w),
                                          padding: EdgeInsets.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        icon: Icon(
                                          Icons.edit_rounded,
                                          color: AppColors.PRIMARY_COLOR,
                                          size: 5.w,
                                        ),
                                      ),
                                      SizedBox(width: 1.w),

                                      ///Delete
                                      IconButton(
                                        onPressed: () {
                                          showDeleteDialog(
                                            ctx: context,
                                            title: AppStrings.areYouSureYouWantToDeleteThisParty.tr,
                                            onPressed: () {
                                              Get.back();
                                              controller.deletePartyApiCall(orderId: data.orderId ?? "");
                                            },
                                          );
                                        },
                                        style: IconButton.styleFrom(
                                          backgroundColor: AppColors.DARK_RED_COLOR,
                                          maximumSize: Size.square(8.w),
                                          minimumSize: Size.square(8.w),
                                          padding: EdgeInsets.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        icon: Obx(() {
                                          if (controller.deletingId.value == data.orderId) {
                                            return SizedBox.square(
                                              dimension: 3.5.w,
                                              child: CircularProgressIndicator(
                                                color: AppColors.PRIMARY_COLOR,
                                                strokeWidth: 1.5,
                                              ),
                                            );
                                          } else {
                                            return Icon(
                                              Icons.delete_rounded,
                                              color: AppColors.WHITE_COLOR,
                                              size: 5.w,
                                            );
                                          }
                                        }),
                                      ),
                                    ],
                                  ),
                                  collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                  backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                  iconColor: AppColors.SECONDARY_COLOR,
                                  collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide.none,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide.none,
                                  ),
                                  childrenPadding: EdgeInsets.symmetric(horizontal: 2.w).copyWith(bottom: 2.h),
                                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 1.5.h);
                      },
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

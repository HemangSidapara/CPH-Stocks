import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/ledger_view.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/pending_payment_screen/pending_payment_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/refresh_indicator_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PendingPaymentView extends GetView<PendingPaymentController> {
  const PendingPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.TRANSPARENT,
          leadingWidth: 0,
          leading: SizedBox.shrink(),
          actionsPadding: EdgeInsets.zero,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomHeaderWidget(
                title: AppStrings.pendingPayment.tr,
                titleIcon: AppAssets.pendingPaymentIcon,
                onBackPressed: () {
                  Get.back(closeOverlays: true);
                },
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ///Search Party
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
                      controller.searchPartyNameController.clear();
                      controller.searchParty(controller.searchPartyNameController.text);
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.SECONDARY_COLOR,
                      size: 5.w,
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 12.w, minWidth: 12.w),
                  hintText: AppStrings.searchParty.tr,
                  controller: controller.searchPartyNameController,
                  onChanged: (value) {
                    controller.searchParty(value);
                  },
                ),
              ),
              SizedBox(height: 1.5.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${AppStrings.totalPayment.tr}:  ${NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(controller.totalPendingAmount.value)}",
                            style: AppStyles.size16w600,
                          ),
                        ),
                        SizedBox(width: 1.w),

                        if (controller.endDate.isNotEmpty) ...[
                          IconButton(
                            onPressed: () {
                              controller.endDate("");
                              controller.getPendingPaymentApiCall(isRefresh: true);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.TERTIARY_COLOR.withValues(alpha: 0.5),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.square(6.5.w),
                              maximumSize: Size.square(6.5.w),
                              padding: EdgeInsets.zero,
                            ),
                            icon: Icon(
                              Icons.close_rounded,
                              color: AppColors.PRIMARY_COLOR,
                              size: 4.5.w,
                            ),
                          ),
                          SizedBox(width: 1.w),
                        ],
                        ElevatedButton(
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 50),
                              lastDate: DateTime(DateTime.now().year + 50),
                              builder: (context, child) {
                                return LedgerView().themeData(context: context, child: child!);
                              },
                            ).then((value) {
                              if (value != null) {
                                controller.endDate.value = DateFormat("dd/MM/yyyy").format(value);
                              }
                            });
                            controller.getPendingPaymentApiCall(isRefresh: true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.FACEBOOK_BLUE_COLOR,
                            elevation: 4,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(8.w, 8.w),
                            maximumSize: Size(25.w, 8.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: AppColors.WHITE_COLOR,
                                  size: 5.w,
                                ),
                                if (controller.endDate.isNotEmpty) ...[
                                  SizedBox(width: 1.w),
                                  Text(
                                    controller.endDate.value,
                                    style: AppStyles.size14w600,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              SizedBox(height: 0.5.h),

              Expanded(
                child: RefreshIndicatorWidget(
                  onRefresh: () async {
                    await controller.getPendingPaymentApiCall(isRefresh: true);
                  },
                  child: Obx(() {
                    if (controller.isLoading.isTrue) {
                      return Center(
                        child: LoadingWidget(),
                      );
                    } else if (controller.searchPendingPaymentList.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          child: NoDataFoundWidget(
                            subtitle: AppStrings.noPendingPaymentsFound.tr,
                            onPressed: () {
                              Utils.unfocus();
                              controller.searchPartyNameController.clear();
                              controller.getPendingPaymentApiCall();
                            },
                          ),
                        ),
                      );
                    } else {
                      return AnimationLimiter(
                        child: ListView.separated(
                          itemCount: controller.searchPendingPaymentList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h).copyWith(bottom: 2.h),
                          itemBuilder: (context, index) {
                            final data = controller.searchPendingPaymentList[index];
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
                                      title: Row(
                                        children: [
                                          ///Party Name
                                          Expanded(
                                            child: Text(
                                              data.partyName ?? "",
                                              style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                            ),
                                          ),
                                          SizedBox(width: 2.w),

                                          ///Pending Amount
                                          Text(
                                            data.pendingAmount != null ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.pendingAmount) : "",
                                            style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                          ),
                                        ],
                                      ),
                                      enabled: false,
                                      tilePadding: EdgeInsets.symmetric(horizontal: 3.w),
                                      dense: true,
                                      showTrailingIcon: false,
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
                                      childrenPadding: EdgeInsets.only(bottom: 2.h),
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
        ),
      ),
    );
  }
}

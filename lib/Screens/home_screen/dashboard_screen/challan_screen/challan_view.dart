import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/invoice_view.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChallanView extends GetView<ChallanController> {
  const ChallanView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
            child: Column(
              children: [
                ///Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomHeaderWidget(
                      title: AppStrings.challan.tr,
                      titleIcon: AppAssets.challanIcon,
                      onBackPressed: () {
                        Get.back(closeOverlays: true);
                      },
                    ),
                    Obx(() {
                      return IconButton(
                        onPressed: controller.isRefreshing.value
                            ? () {}
                            : () async {
                                await controller.getInvoicesApi(isLoading: false);
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
                      controller.searchPartyName("");
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

                ///Invoices
                Expanded(
                  child: Obx(() {
                    if (controller.isGetInvoicesLoading.isTrue) {
                      return const Center(
                        child: LoadingWidget(),
                      );
                    } else if (controller.searchedInvoiceList.isEmpty) {
                      return Expanded(
                        child: NoDataFoundWidget(
                          subtitle: AppStrings.noDataFound.tr,
                          onPressed: () {
                            controller.getInvoicesApi(isLoading: false);
                          },
                        ),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: controller.searchedInvoiceList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final orderInvoice = controller.searchedInvoiceList[index];
                          return Card(
                            color: AppColors.TRANSPARENT,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpansionTile(
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${orderInvoice.challanNumber ?? ''}. ",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.DARK_RED_COLOR,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Expanded(
                                          child: Text(
                                            controller.searchedInvoiceList[index].partyName ?? '',
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
                                  SizedBox(width: 2.w),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ///View Invoice
                                      ElevatedButton(
                                        onPressed: () {
                                          showInvoiceBottomSheet(
                                            ctx: context,
                                            partyName: orderInvoice.partyName ?? '',
                                            challanNumber: orderInvoice.challanNumber ?? '',
                                            createdDate: orderInvoice.createdDate ?? '',
                                            invoiceData: orderInvoice.invoiceMeta ?? [],
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.ORANGE_COLOR,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          minimumSize: Size(12.w, 8.w),
                                          maximumSize: Size(12.w, 8.w),
                                          padding: EdgeInsets.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Icon(
                                          Icons.visibility_rounded,
                                          size: 5.w,
                                          color: AppColors.PRIMARY_COLOR,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              dense: true,
                              collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                              backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                              iconColor: AppColors.SECONDARY_COLOR,
                              collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              childrenPadding: EdgeInsets.only(bottom: 2.h),
                              tilePadding: EdgeInsets.symmetric(horizontal: 3.w),
                              showTrailingIcon: false,
                              children: [
                                Divider(
                                  color: AppColors.HINT_GREY_COLOR,
                                  thickness: 1,
                                ),
                                SizedBox(height: 1.h),

                                ///Created At
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${AppStrings.createdAt.tr}: ",
                                        style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                      ),
                                      Text(
                                        "${orderInvoice.createdDate ?? ''}, ${DateFormat("hh:mm a").format(DateFormat("hh:mm:ss").parse(orderInvoice.createdTime!))}".trim(),
                                        style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                      ),
                                    ],
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

  /// @function showInvoiceBottomSheet
  /// @description show invoice bottom sheet
  /// @param {BuildContext} ctx - BuildContext object
  /// @param {String} partyName - Party name
  /// @param {String} challanNumber - Challan number
  /// @param {String} createdDate - Created date
  /// @param {List<InvoiceMeta>} invoiceData - List of invoice data
  /// @returns {Future<void>} - Returns a Future of a void value
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<void> showInvoiceBottomSheet({
    required BuildContext ctx,
    required String partyName,
    required String challanNumber,
    required String createdDate,
    required List<InvoiceMeta> invoiceData,
  }) async {
    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        return InvoiceView(
          partyName: partyName,
          challanNumber: challanNumber,
          createdDate: createdDate,
          invoiceData: invoiceData,
        );
      },
    );
  }
}

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/services/utils_services/download_service.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/view_cycles_screen/view_cycles_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class ViewCyclesView extends GetView<ViewCyclesController> {
  const ViewCyclesView({super.key});

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
                      title: AppStrings.viewCycles.tr,
                      titleIcon: AppAssets.viewCyclesIcon,
                      titleIconSize: 8.w,
                      onBackPressed: () {
                        Get.back(closeOverlays: true);
                      },
                    ),
                    // IconButton(
                    //   onPressed: () async {
                    //     if (controller.challanUrl.value.isNotEmpty) {
                    //       await showChallanBottomSheet(pdfUrl: controller.challanUrl.value);
                    //     } else {
                    //       Utils.handleMessage(message: AppStrings.noDataFound.tr, isWarning: true);
                    //     }
                    //   },
                    //   style: IconButton.styleFrom(
                    //     backgroundColor: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                    //     surfaceTintColor: AppColors.PRIMARY_COLOR,
                    //     highlightColor: AppColors.PRIMARY_COLOR,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     elevation: 4,
                    //     padding: EdgeInsets.zero,
                    //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //   ),
                    //   icon: Icon(
                    //     Icons.receipt_long_rounded,
                    //     color: AppColors.SECONDARY_COLOR,
                    //     size: 6.5.w,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 4.h),

                Expanded(
                  child: Obx(() {
                    if (controller.isGetOrderCycleLoading.isTrue) {
                      return const Center(
                        child: LoadingWidget(),
                      );
                    } else if (controller.orderCycleList.isEmpty) {
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
                        itemCount: controller.orderCycleList.length,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}. ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.SECONDARY_COLOR,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      controller.orderCycleList[index].createdDate != null || controller.orderCycleList[index].createdDate?.isNotEmpty == true ? DateFormat("MMMM dd, yyyy hh:mm a").format(DateTime.parse(controller.orderCycleList[index].createdDate!).toLocal()) : '',
                                      style: TextStyle(
                                        color: AppColors.SECONDARY_COLOR,
                                        fontSize: 15.sp,
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
                              childrenPadding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
                              children: [
                                Divider(
                                  color: AppColors.HINT_GREY_COLOR,
                                  thickness: 1,
                                ),

                                ///OK Pcs
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
                                      controller.orderCycleList[index].okPcs ?? '',
                                      style: TextStyle(
                                        shadows: [
                                          Shadow(
                                            color: AppColors.PRIMARY_COLOR,
                                            blurRadius: 40,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.DARK_GREEN_COLOR,
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
                                      controller.orderCycleList[index].woProcess ?? '',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.DARK_RED_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),

                                ///Pending
                                Row(
                                  children: [
                                    Text(
                                      "${AppStrings.pending.tr}: ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Text(
                                      controller.orderCycleList[index].pending ?? '',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.FACEBOOK_BLUE_COLOR,
                                      ),
                                    ),
                                  ],
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

  Future<void> showChallanBottomSheet({required String pdfUrl}) async {
    await showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints(maxWidth: 100.w, minWidth: 100.w, maxHeight: 95.h, minHeight: 0.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.PRIMARY_COLOR,
      builder: (context) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Back & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Title
                    Text(
                      AppStrings.viewChallan.tr,
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
                SizedBox(height: 3.h),

                ///Viewer
                Flexible(
                  child: SfPdfViewerTheme(
                    data: SfPdfViewerThemeData(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      progressBarColor: AppColors.TERTIARY_COLOR,
                    ),
                    child: SfPdfViewer.network(
                      pdfUrl,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///Download
                    ElevatedButton(
                      onPressed: () async {
                        await Get.put(DownloaderService()).fileDownloadService(
                          url: pdfUrl,
                          fileName: "${controller.arguments.partyName?.replaceAll(' ', '')}_${controller.arguments.itemName?.replaceAll(' ', '')}.pdf",
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
                      child: Icon(
                        Icons.download_rounded,
                        color: AppColors.PRIMARY_COLOR,
                        size: 6.w,
                      ),
                    ),

                    ///Share
                    ElevatedButton(
                      onPressed: () async {
                        final isExist = await WhatsappShare.isInstalled();
                        if (isExist == true) {
                          final cacheFile = await Get.put(DownloaderService()).fileDownloadService(
                            url: pdfUrl,
                            fileName: "${controller.arguments.partyName?.replaceAll(' ', '')}_${controller.arguments.itemName?.replaceAll(' ', '')}.pdf",
                            showLoader: false,
                          );
                          if (cacheFile != null) {
                            await WhatsappShare.shareFile(
                              phone: '91${controller.contactNumber.value}',
                              filePath: [cacheFile.path],
                            );
                          }
                        } else {
                          Utils.handleMessage(message: AppStrings.whatsappNotInstalled.tr, isWarning: true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.LIGHT_BLUE_COLOR,
                        fixedSize: Size(35.w, 5.h),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: AppColors.PRIMARY_COLOR,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

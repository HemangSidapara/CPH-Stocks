import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/services/utils_services/download_service.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class ChallanView extends GetView<ChallanController> {
  const ChallanView({super.key});

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

                ///Invoices
                Expanded(
                  child: Obx(() {
                    if (controller.isGetInvoicesLoading.isTrue) {
                      return const Center(
                        child: LoadingWidget(),
                      );
                    } else if (controller.searchedInvoiceList.isEmpty) {
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
                        itemCount: controller.searchedInvoiceList.length,
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
                                SizedBox(height: 1.h),

                                ///Items
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 60.h,
                                  ),
                                  child: ListView.separated(
                                    itemCount: controller.searchedInvoiceList[index].modelMeta?.length ?? 0,
                                    shrinkWrap: true,
                                    itemBuilder: (context, itemIndex) {
                                      return DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: AppColors.PRIMARY_COLOR.withOpacity(0.7),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                                          child: Row(
                                            children: [
                                              ///ItemName
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
                                                        controller.searchedInvoiceList[index].modelMeta?[itemIndex].itemName ?? '',
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

                                              ///Download
                                              IconButton(
                                                onPressed: () async {
                                                  await showChallanBottomSheet(
                                                    pdfUrl: controller.searchedInvoiceList[index].modelMeta?[itemIndex].invoice ?? '',
                                                    fileName: "${controller.searchedInvoiceList[index].partyName?.replaceAll(' ', '')}_${controller.searchedInvoiceList[index].modelMeta?[itemIndex].itemName?.replaceAll(' ', '')}.pdf",
                                                    contactNumber: controller.searchedInvoiceList[index].contactNumber ?? '',
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.download_rounded,
                                                  color: AppColors.DARK_RED_COLOR,
                                                  size: 6.5.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
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

  Future<void> showChallanBottomSheet({
    required String pdfUrl,
    required String fileName,
    required String contactNumber,
  }) async {
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///Download
                    ElevatedButton(
                      onPressed: () async {
                        await Get.put(DownloaderService()).fileDownloadService(
                          url: pdfUrl,
                          fileName: fileName,
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
                            fileName: fileName,
                            showLoader: false,
                          );
                          if (cacheFile != null) {
                            await WhatsappShare.shareFile(
                              phone: '91$contactNumber',
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

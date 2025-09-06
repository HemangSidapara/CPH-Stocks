import 'dart:io';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_controller.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvoiceView extends StatefulWidget {
  final String partyName;
  final String challanNumber;
  final String createdDate;
  final bool isLandscape;
  final List<InvoiceMeta> invoiceData;

  const InvoiceView({
    super.key,
    required this.invoiceData,
    required this.partyName,
    required this.challanNumber,
    required this.createdDate,
    this.isLandscape = true,
  });

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  ChallanController controller = Get.isRegistered<ChallanController>() ? Get.find<ChallanController>() : Get.put(ChallanController());
  RxBool generatingInvoice = false.obs;
  Rx<File> pdfFile = File("").obs;

  RxBool isAmountVisible = false.obs;

  @override
  void initState() {
    super.initState();
    setGenerateInvoice();
  }

  Future<void> setGenerateInvoice() async {
    try {
      generatingInvoice(true);
      final file = await controller.generatePdf(
        partyName: widget.partyName,
        challanNumber: widget.challanNumber,
        createdDate: widget.createdDate,
        data: widget.invoiceData,
        isLandscape: widget.isLandscape,
        showAmount: isAmountVisible.isTrue,
      );
      if (file != null) {
        pdfFile.value = file;
      }
    } finally {
      generatingInvoice(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Back & Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(right: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Title
              Text(
                AppStrings.viewChallan.tr,
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),

              ///Back
              CloseButtonWidget(),
            ],
          ),
        ),
        DividerWidget(color: AppColors.HINT_GREY_COLOR),
        SizedBox(height: 1.h),

        ///Amount
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: GestureDetector(
            onTap: () {
              isAmountVisible.toggle();
              setGenerateInvoice();
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  AppStrings.amount.tr,
                  style: AppStyles.size16w600,
                ),
                SizedBox(width: 2.w),
                SizedBox(
                  width: 10.5.w,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Obx(() {
                        return Switch.adaptive(
                          value: isAmountVisible.isTrue,
                          onChanged: (value) {},
                          activeThumbColor: AppColors.SECONDARY_COLOR,
                          inactiveTrackColor: AppColors.SECONDARY_COLOR,
                          activeTrackColor: AppColors.PRIMARY_COLOR,
                          inactiveThumbColor: AppColors.PRIMARY_COLOR,
                          trackOutlineColor: WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 1.h),

        ///Viewer
        Obx(() {
          if (generatingInvoice.isTrue) {
            return Expanded(
              child: Center(
                child: LoadingWidget(),
              ),
            );
          } else {
            return Flexible(
              child: RotatedBox(
                quarterTurns: widget.isLandscape ? 3 : 0,
                child: SfPdfViewerTheme(
                  data: SfPdfViewerThemeData(
                    backgroundColor: AppColors.TRANSPARENT,
                    progressBarColor: AppColors.TERTIARY_COLOR,
                    paginationDialogStyle: PdfPaginationDialogStyle(
                      backgroundColor: AppColors.SECONDARY_COLOR,
                      cancelTextStyle: AppStyles.size16w600.copyWith(color: AppColors.PRIMARY_COLOR),
                      okTextStyle: AppStyles.size16w600.copyWith(color: AppColors.PRIMARY_COLOR),
                      headerTextStyle: AppStyles.size18w600.copyWith(color: AppColors.PRIMARY_COLOR),
                      hintTextStyle: AppStyles.size16w600.copyWith(color: AppColors.HINT_GREY_COLOR),
                      pageInfoTextStyle: AppStyles.size16w600.copyWith(color: AppColors.PRIMARY_COLOR),
                      inputFieldTextStyle: AppStyles.size16w600.copyWith(color: AppColors.PRIMARY_COLOR),
                      validationTextStyle: AppStyles.size15w600.copyWith(color: AppColors.DARK_RED_COLOR),
                    ),
                    scrollHeadStyle: PdfScrollHeadStyle(
                      backgroundColor: AppColors.SECONDARY_COLOR,
                      pageNumberTextStyle: AppStyles.size15w600.copyWith(color: AppColors.PRIMARY_COLOR),
                    ),
                  ),
                  child: SfPdfViewer.file(
                    pdfFile.value,
                    maxZoomLevel: 10,
                    pageLayoutMode: PdfPageLayoutMode.single,
                    scrollDirection: PdfScrollDirection.vertical,
                    onDocumentLoadFailed: (details) {
                      if (kDebugMode) {
                        print("SfPdfViewer error :: ${details.description}");
                      }
                      Utils.handleMessage(message: details.description, isError: true);
                    },
                  ),
                ),
              ),
            );
          }
        }),
        SizedBox(height: 2.h),

        ///Download, Print & Share
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ///Download
            ElevatedButton(
              onPressed: () async {
                final downloadedFile = await Utils.getDashboardController.downloadPdf(pdfFile: pdfFile.value);
                if (downloadedFile != null && downloadedFile.existsSync()) {
                  Utils.handleMessage(
                    message: AppStrings.successfullyDownloadedAtDownloadFolder.tr,
                    onTap: () async {
                      OpenFilex.open(downloadedFile.path);
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.DARK_GREEN_COLOR,
                fixedSize: Size(30.w, 5.h),
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

            ///Print
            ElevatedButton(
              onPressed: () async {
                Utils.getDashboardController.printPdf(pdfFile: pdfFile.value);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ORANGE_COLOR,
                fixedSize: Size(30.w, 5.h),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Icon(
                Icons.print_rounded,
                color: AppColors.PRIMARY_COLOR,
                size: 6.w,
              ),
            ),

            ///Share
            ElevatedButton(
              onPressed: () async {
                Utils.getDashboardController.sharePdf(
                  pdfFiles: [
                    pdfFile.value,
                  ],
                  shareText: AppStrings.shareInvoice.tr,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.LIGHT_BLUE_COLOR,
                fixedSize: Size(30.w, 5.h),
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
        SizedBox(height: 3.h),
      ],
    );
  }
}

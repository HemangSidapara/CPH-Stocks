import 'dart:io';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/ledger_controller.dart';
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

class PendingPaymentsPdfView extends StatefulWidget {
  const PendingPaymentsPdfView({
    super.key,
  });

  @override
  State<PendingPaymentsPdfView> createState() => _PendingPaymentsPdfViewState();
}

class _PendingPaymentsPdfViewState extends State<PendingPaymentsPdfView> with SingleTickerProviderStateMixin {
  LedgerController controller = Get.isRegistered<LedgerController>() ? Get.find<LedgerController>() : Get.put(LedgerController());
  RxBool generatingPdf = false.obs;
  RxList<File> pendingPaymentsPdfFile = RxList();

  late TabController tabController;

  List<String> paymentMode = [
    AppStrings.without,
    AppStrings.withKey,
    AppStrings.cash,
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    Future.wait(
      paymentMode.indexed.map((e) async {
        pendingPaymentsPdfFile.add(File(""));
        await setGenerateInvoice(modeIndex: e.$1);
      }),
    );
  }

  Future<void> setGenerateInvoice({required int modeIndex}) async {
    try {
      generatingPdf(true);
      final pdfFile = await controller.generatePendingPaymentsPdf(
        mode: paymentMode[modeIndex],
      );
      if (pdfFile != null) {
        pendingPaymentsPdfFile[modeIndex] = pdfFile;
      }
    } finally {
      generatingPdf(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Back & Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(right: 2.w, top: 0.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Title
              Text(
                AppStrings.viewPendingPayment.tr,
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

        TabBar(
          controller: tabController,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          tabAlignment: TabAlignment.fill,
          labelPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
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
          tabs: paymentMode
              .map(
                (e) => Text(
                  e.tr,
                  style: AppStyles.size16w600.copyWith(fontWeight: FontWeight.w700),
                ),
              )
              .toList(),
        ),

        Expanded(
          child: TabBarView(
            controller: tabController,
            children: paymentMode.indexed
                .map(
                  (e) => Obx(() {
                    return PdfViewWidget(pdfFile: pendingPaymentsPdfFile[e.$1]);
                  }),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget PdfViewWidget({required File pdfFile}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 1.h),

        ///Viewer
        Obx(() {
          if (generatingPdf.isTrue) {
            return Expanded(
              child: Center(
                child: LoadingWidget(),
              ),
            );
          } else {
            return Flexible(
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
                  pdfFile,
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
                final downloadedFile = await Utils.getDashboardController.downloadPdf(pdfFile: pdfFile);
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
                Utils.getDashboardController.printPdf(pdfFile: pdfFile, isLandscape: false);
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
                  pdfFiles: [pdfFile],
                  shareText: AppStrings.sharePendingPayment.tr,
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

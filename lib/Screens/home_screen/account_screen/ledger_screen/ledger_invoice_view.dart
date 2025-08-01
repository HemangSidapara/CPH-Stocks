import 'dart:io';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/account_models/get_payment_ledger_model.dart' as get_payment_ledger;
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart';
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

class LedgerInvoiceView extends StatefulWidget {
  final get_payment_ledger.GetPaymentLedgerModel? paymentLedgerInvoiceData;
  final List<OrderInvoice> ledgerInvoiceData;
  final bool isPaymentLedger;
  final String? startDate;
  final String? endDate;

  const LedgerInvoiceView({
    super.key,
    required this.ledgerInvoiceData,
    this.paymentLedgerInvoiceData,
    required this.isPaymentLedger,
    this.startDate,
    this.endDate,
  });

  @override
  State<LedgerInvoiceView> createState() => _LedgerInvoiceViewState();
}

class _LedgerInvoiceViewState extends State<LedgerInvoiceView> with SingleTickerProviderStateMixin {
  LedgerController controller = Get.isRegistered<LedgerController>() ? Get.find<LedgerController>() : Get.put(LedgerController());
  RxBool generatingInvoice = false.obs;
  Rx<File> ledgerPdfFile = File("").obs;
  Rx<File> paymentLedgerPdfFile = File("").obs;

  RxBool isAmountVisible = false.obs;

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    setGenerateInvoice();
  }

  Future<void> setGenerateInvoice() async {
    try {
      generatingInvoice(true);
      final ledgerFile = await controller.generateLedgerPdf(
        startDate: widget.startDate,
        endDate: widget.endDate,
        data: widget.ledgerInvoiceData,
        selectedPartyId: widget.ledgerInvoiceData.firstOrNull?.partyId,
        showAmount: isAmountVisible.isTrue,
      );
      if (ledgerFile != null) {
        ledgerPdfFile.value = ledgerFile;
      }
      if (widget.isPaymentLedger && widget.paymentLedgerInvoiceData != null) {
        final paymentLedgerFile = await controller.generatePaymentLedgerPdf(
          data: widget.paymentLedgerInvoiceData!,
          showAmount: isAmountVisible.isTrue,
        );

        if (paymentLedgerFile != null) {
          paymentLedgerPdfFile.value = paymentLedgerFile;
        }
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
          padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(right: 2.w, top: 0.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Title
              Text(
                widget.isPaymentLedger ? AppStrings.viewPaymentLedger.tr : AppStrings.viewLedger.tr,
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),

              ///Back
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isPaymentLedger) ...[
                    ElevatedButton(
                      onPressed: () {
                        Utils.getDashboardController.sharePdf(
                          pdfFiles: [
                            ledgerPdfFile.value,
                            paymentLedgerPdfFile.value,
                          ],
                          shareText: widget.isPaymentLedger ? AppStrings.sharePaymentLedger.tr : AppStrings.shareLedgerInvoice.tr,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.FACEBOOK_BLUE_COLOR,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        maximumSize: Size.square(9.w),
                        minimumSize: Size.square(9.w),
                        elevation: 4,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.whatsapp,
                        size: 5.w,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                    SizedBox(width: 2.w),
                  ],
                  CloseButtonWidget(),
                ],
              ),
            ],
          ),
        ),
        DividerWidget(color: AppColors.HINT_GREY_COLOR),

        ///Tabs
        if (widget.isPaymentLedger) ...[
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
            onTap: (value) {
              Utils.unfocus();
              tabIndex(value);
            },
            tabs: [
              Text(
                AppStrings.ledger.tr,
                style: TextStyle(
                  color: AppColors.WHITE_COLOR,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                AppStrings.paymentLedger.tr,
                style: TextStyle(
                  color: AppColors.WHITE_COLOR,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                ///Ledger
                Obx(() {
                  return LedgerInvoiceWidget(ledgerFile: ledgerPdfFile.value);
                }),

                ///Payment Ledger
                Obx(() {
                  return PaymentLedgerInvoiceWidget(paymentLedgerFile: paymentLedgerPdfFile.value);
                }),
              ],
            ),
          ),
        ] else ...[
          Expanded(
            child: Obx(() {
              return LedgerInvoiceWidget(ledgerFile: ledgerPdfFile.value);
            }),
          ),
        ],
      ],
    );
  }

  Widget LedgerInvoiceWidget({required File ledgerFile}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                          activeColor: AppColors.SECONDARY_COLOR,
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
                  ledgerFile,
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
                final downloadedFile = await Utils.getDashboardController.downloadPdf(pdfFile: ledgerFile);
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
                Utils.getDashboardController.printPdf(pdfFile: ledgerFile, isLandscape: false);
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
                  pdfFiles: [ledgerFile],
                  shareText: widget.isPaymentLedger ? AppStrings.sharePaymentLedger.tr : AppStrings.shareLedgerInvoice.tr,
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

  Widget PaymentLedgerInvoiceWidget({required File paymentLedgerFile}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                  paymentLedgerFile,
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
                final downloadedFile = await Utils.getDashboardController.downloadPdf(pdfFile: paymentLedgerFile);
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
                Utils.getDashboardController.printPdf(pdfFile: paymentLedgerFile, isLandscape: false);
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
                  pdfFiles: [paymentLedgerFile],
                  shareText: widget.isPaymentLedger ? AppStrings.sharePaymentLedger.tr : AppStrings.shareLedgerInvoice.tr,
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

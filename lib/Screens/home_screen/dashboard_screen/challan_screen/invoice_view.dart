import 'dart:io';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_controller.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
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
  final List<InvoiceMeta> invoiceData;

  const InvoiceView({
    super.key,
    required this.invoiceData,
    required this.partyName,
    required this.challanNumber,
    required this.createdDate,
  });

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  ChallanController controller = Get.find<ChallanController>();
  RxBool generatingInvoice = false.obs;
  Rx<File> pdfFile = File("").obs;

  @override
  void initState() {
    super.initState();
    generatingInvoice(true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final file = await controller.generatePdf(
        partyName: widget.partyName,
        challanNumber: widget.challanNumber,
        createdDate: widget.createdDate,
        data: widget.invoiceData,
      );
      if (file != null) {
        pdfFile.value = file;
      }
      generatingInvoice(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Back & Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
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
        Divider(
          color: AppColors.HINT_GREY_COLOR,
          thickness: 1,
        ),
        SizedBox(height: 3.h),

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
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  progressBarColor: AppColors.TERTIARY_COLOR,
                ),
                child: SfPdfViewer.file(
                  pdfFile.value,
                  maxZoomLevel: 10,
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
                final downloadedFile = await controller.downloadPdf(pdfFile: pdfFile.value);
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
                controller.printPdf(pdfFile: pdfFile.value);
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
                controller.sharePdf(pdfFile: pdfFile.value);
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

import 'dart:io';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart' as get_invoices;
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/challan_services/challan_service.dart';
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/ledger_screen/ledger_invoice_view.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class LedgerController extends GetxController {
  GlobalKey<FormState> ledgerFormKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();

  RxBool isGenerateLoading = false.obs;

  RxList<get_parties.Data> partyList = <get_parties.Data>[].obs;
  RxString selectedParty = "".obs;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getPartiesApi();
  }

  String? validatePartyName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectParty.tr;
    }
    return null;
  }

  String? validateStartDate(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectStartDate.tr;
    }
    return null;
  }

  String? validateEndDate(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectEndDate.tr;
    }
    return null;
  }

  Future<RxList<get_parties.Data>> getPartiesApi() async {
    final response = await OrderServices.getPartiesService();
    if (response.isSuccess) {
      get_parties.GetPartiesModel getPartiesModel = get_parties.GetPartiesModel.fromJson(response.response?.data);
      partyList.clear();
      partyList.addAll(getPartiesModel.data ?? []);
    }
    return partyList;
  }

  Future<void> generateLedgerApi() async {
    try {
      isGenerateLoading(true);
      if (ledgerFormKey.currentState?.validate() ?? false) {
        final response = await ChallanService.generateLedgerInvoiceService(
          startDate: startDateController.text,
          endDate: endDateController.text,
          partyId: selectedParty.value,
        );

        if (response.isSuccess) {
          get_invoices.GetInvoicesModel invoicesModel = get_invoices.GetInvoicesModel.fromJson(response.response?.data);
          if (invoicesModel.data?.isNotEmpty == true) {
            showInvoiceBottomSheet(
              ctx: Get.context!,
              invoiceData: invoicesModel.data ?? [],
            );
          } else {
            Utils.handleMessage(message: AppStrings.noChallanAvailableYet.tr, isError: true);
          }
        }
      }
    } finally {
      isGenerateLoading(false);
    }
  }

  Future<void> showInvoiceBottomSheet({
    required BuildContext ctx,
    required List<get_invoices.OrderInvoice> invoiceData,
  }) async {
    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        return LedgerInvoiceView(
          invoiceData: invoiceData,
        );
      },
    );
  }

  Future<File?> generateLedgerPdf({
    required List<get_invoices.OrderInvoice> data,
    bool showAmount = false,
  }) async {
    final pdfDoc = pw.Document();

    pw.TextStyle size20Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle size18Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle size16Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle size14Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle size12Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );

    pw.Widget TableCell({
      required String title,
    }) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: pw.Text(
          title,
          style: size12Font,
        ),
      );
    }

    pw.Widget TableHeadingCell({
      required String title,
    }) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: pw.Text(
          title,
          style: size12Font,
        ),
      );
    }

    double totalAmountCount(List<get_invoices.InvoiceMeta> invoiceMetaData) {
      final listOfAmounts = invoiceMetaData.where((element) => element.totalAmount != null && element.totalAmount?.isNotEmpty == true).toList().map((e) => e.totalAmount!.toDouble()).toList();
      return listOfAmounts.isNotEmpty ? listOfAmounts.reduce((value, element) => value + element) : 0.0;
    }

    double totalInchCount(List<get_invoices.InvoiceMeta> invoiceMetaData) {
      final listOfInch = invoiceMetaData.where((element) => element.totalInch != null && element.totalInch?.isNotEmpty == true).toList().map((e) => e.totalInch!.toDouble()).toList();
      return listOfInch.isNotEmpty ? listOfInch.reduce((value, element) => value + element) : 0.0;
    }

    double megaTotalAmountCount() {
      final totalInvoices = data.map((e) => e.invoiceMeta ?? []).toList();
      final listOfAmount = totalInvoices.map((e) => totalAmountCount(e)).toList();
      return listOfAmount.isNotEmpty ? listOfAmount.reduce((value, element) => value + element) : 0.0;
    }

    double megaTotalInchCount() {
      final totalInvoices = data.map((e) => e.invoiceMeta ?? []).toList();
      final listOfInch = totalInvoices.map((e) => totalInchCount(e)).toList();
      return listOfInch.isNotEmpty ? listOfInch.reduce((value, element) => value + element) : 0.0;
    }

    final ttfRegular = pw.Font.ttf(await rootBundle.load(AppAssets.robotoRegular));
    final ttfBold = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBold));
    final ttfItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoItalic));
    final ttfBoldItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBoldItalic));

    pdfDoc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pdf.PdfPageFormat.a4,
          margin: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          theme: pw.ThemeData.withFont(
            base: ttfRegular,
            bold: ttfBold,
            italic: ttfItalic,
            boldItalic: ttfBoldItalic,
            icons: ttfBold,
          ),
        ),
        build: (context) {
          return <pw.Widget>[
            /// Ledger Title
            if (data.isNotEmpty) ...[
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  /// Party Name
                  pw.Flexible(
                    child: pw.Text(
                      data.first.partyName ?? "",
                      style: size20Font,
                    ),
                  ),
                  pw.SizedBox(width: 10),

                  /// Date Range
                  pw.Flexible(
                    child: pw.Text(
                      "${AppStrings.date.tr}: ${DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(startDateController.text))} - ${DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(endDateController.text))}",
                      style: size20Font,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
            ],

            for (int invoiceIndex = 0; invoiceIndex < data.length; invoiceIndex++) ...[
              /// Title
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  /// Challan Number
                  pw.Text(
                    data[invoiceIndex].challanNumber ?? "",
                    style: size18Font,
                  ),
                  pw.SizedBox(width: 10),

                  /// Created Date
                  pw.Text(
                    "${AppStrings.date.tr}: ${DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(data[invoiceIndex].createdDate ?? ""))}",
                    style: size18Font,
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              /// Invoice Table
              pw.Table(
                border: pw.TableBorder.all(
                  color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                  width: 1,
                ),
                children: [
                  /// Header
                  pw.TableRow(
                    children: [
                      /// SR.
                      pw.SizedBox(
                        width: 35,
                        child: TableHeadingCell(title: AppStrings.sr.tr.replaceAll(".", "")),
                      ),

                      /// Category
                      pw.SizedBox(
                        width: 70,
                        child: TableHeadingCell(title: AppStrings.category.tr),
                      ),

                      /// PVD Color
                      pw.SizedBox(
                        width: 50,
                        child: TableHeadingCell(title: AppStrings.pvdColor.tr),
                      ),

                      /// Item
                      pw.SizedBox(
                        width: 60,
                        child: TableHeadingCell(title: AppStrings.item.tr),
                      ),

                      /// In Date
                      pw.SizedBox(
                        width: 70,
                        child: TableHeadingCell(title: AppStrings.inDate.tr),
                      ),

                      /// QTY
                      TableHeadingCell(title: AppStrings.qty.tr),

                      /// Previous
                      pw.SizedBox(
                        width: 43,
                        child: TableHeadingCell(title: AppStrings.previous.tr),
                      ),

                      /// OK
                      TableHeadingCell(title: AppStrings.ok.tr),

                      /// W/O
                      TableHeadingCell(title: AppStrings.wo.tr),

                      /// Inch
                      TableHeadingCell(title: AppStrings.inch.tr),

                      /// Total Inch
                      pw.SizedBox(
                        width: 60,
                        child: TableHeadingCell(title: AppStrings.totalInch.tr),
                      ),

                      /// Balance QTY
                      pw.SizedBox(
                        width: 65,
                        child: TableHeadingCell(title: AppStrings.balanceQTY.tr),
                      ),

                      /// Total Amount
                      if (showAmount)
                        pw.SizedBox(
                          width: 75,
                          child: TableHeadingCell(title: AppStrings.totalAmount.tr),
                        ),
                    ],
                  ),

                  for (int i = 0; i < (data[invoiceIndex].invoiceMeta?.length ?? 0); i++) ...[
                    (() {
                      final invoice = data[invoiceIndex].invoiceMeta?[i];
                      return pw.TableRow(
                        children: [
                          /// SR.
                          pw.SizedBox(
                            width: 35,
                            child: TableCell(title: "${i + 1}"),
                          ),

                          /// Category
                          pw.SizedBox(
                            width: 70,
                            child: TableCell(title: invoice?.categoryName ?? ""),
                          ),

                          /// PVD Color
                          pw.SizedBox(
                            width: 50,
                            child: TableCell(title: invoice?.pvdColor ?? ""),
                          ),

                          /// Item
                          pw.SizedBox(
                            width: 60,
                            child: TableCell(title: invoice?.itemName ?? ""),
                          ),

                          /// In Date
                          pw.SizedBox(
                            width: 70,
                            child: TableCell(title: DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(invoice?.inDate ?? ""))),
                          ),

                          /// QTY
                          TableCell(title: invoice?.quantity ?? ""),

                          /// Previous
                          pw.SizedBox(
                            width: 43,
                            child: TableCell(title: invoice?.previous ?? ""),
                          ),

                          /// OK
                          TableCell(title: invoice?.okPcs ?? ""),

                          /// W/O
                          TableCell(title: invoice?.woProcess ?? ""),

                          /// Inch
                          TableCell(title: invoice?.inch ?? ""),

                          /// Total Inch
                          pw.SizedBox(
                            width: 60,
                            child: TableCell(title: invoice?.totalInch ?? ""),
                          ),

                          /// Balance QTY
                          pw.SizedBox(
                            width: 65,
                            child: TableCell(title: invoice?.balanceQuantity ?? ""),
                          ),

                          /// Total Amount
                          if (showAmount)
                            pw.SizedBox(
                              width: 75,
                              child: TableCell(title: invoice?.totalAmount == null && invoice?.totalAmount?.isNotEmpty == true ? NumberFormat.currency(locale: "hi_IN", symbol: "₹", decimalDigits: 0).format(invoice?.totalAmount!.toDouble()) : ""),
                            )
                        ],
                      );
                    })(),
                  ],
                ],
              ),
              pw.SizedBox(height: 5),

              /// Total Inch & Total Amount
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  ///Total Inch
                  pw.Row(
                    children: [
                      pw.Text(
                        "${AppStrings.totalInch.tr}: ",
                        style: size16Font.copyWith(fontSize: 18),
                      ),
                      pw.Text(
                        totalInchCount(data[invoiceIndex].invoiceMeta ?? []).toString(),
                        style: size16Font.copyWith(fontSize: 18),
                      ),
                    ],
                  ),

                  ///Total Amount
                  if (showAmount) ...[
                    pw.SizedBox(width: 14),
                    pw.Text(
                      "${AppStrings.totalAmount.tr}: ",
                      style: size16Font.copyWith(fontSize: 18),
                    ),
                    pw.Text(
                      NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(totalAmountCount(data[invoiceIndex].invoiceMeta ?? [])),
                      style: size16Font.copyWith(fontSize: 18),
                    ),
                  ],
                ],
              ),
              pw.SizedBox(height: 30),
            ],

            /// Mega Total Table of Inch & Amount
            if (data.isNotEmpty) ...[
              pw.Table(
                border: pw.TableBorder.all(
                  color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                  width: 1,
                ),
                children: [
                  /// Heading
                  pw.TableRow(
                    children: [
                      /// Challan Number
                      TableCell(title: AppStrings.challanNumber.tr),

                      /// Mega Total Inch
                      TableCell(title: AppStrings.totalInch.tr),

                      /// Mega Total Amount
                      if (showAmount) TableCell(title: AppStrings.totalAmount.tr),
                    ],
                  ),

                  ///Data
                  for (int i = 0; i < data.length; i++) ...[
                    pw.TableRow(
                      children: [
                        /// Empty Cell
                        TableCell(
                          title: data[i].challanNumber ?? "",
                        ),

                        /// Mega Total Inch
                        TableCell(
                          title: totalInchCount(data[i].invoiceMeta ?? []).toString(),
                        ),

                        /// Mega Total Amount
                        if (showAmount)
                          TableCell(
                            title: NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(
                              totalAmountCount(data[i].invoiceMeta ?? []),
                            ),
                          ),
                      ],
                    ),
                  ],

                  ///Calculation Row
                  pw.TableRow(
                    children: [
                      /// Empty Cell
                      TableCell(
                        title: "",
                      ),

                      /// Mega Total Inch
                      TableCell(
                        title: megaTotalInchCount().toString(),
                      ),

                      /// Mega Total Amount
                      if (showAmount)
                        TableCell(
                          title: NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(
                            megaTotalAmountCount(),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ];
        },
      ),
    );

    final status = await Utils.getDashboardController.permissionStatus();
    if (status.$1.isGranted || status.$2.isGranted) {
      final dir = await getApplicationCacheDirectory();
      final fileName = 'Ledger_${partyList.firstWhereOrNull((element) => element.orderId == selectedParty.value)?.partyName ?? ""}_${startDateController.text}_${endDateController.text}'.cleanFileName;
      final file = File('${dir.path}/$fileName.pdf');
      final fileBytes = await pdfDoc.save();
      return await file.writeAsBytes(fileBytes);
    }
    return null;
  }
}

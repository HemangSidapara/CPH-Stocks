import 'dart:convert';
import 'dart:io';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/account_models/get_automatic_ledger_invoice_model.dart' as get_automatic_ledger_invoice;
import 'package:cph_stocks/Network/models/account_models/get_automatic_ledger_payment_model.dart' as get_automatic_ledger;
import 'package:cph_stocks/Network/models/account_models/get_payment_ledger_model.dart' as get_payment_ledger;
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart' as get_invoices;
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/account_services/account_services.dart';
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/ledger_invoice_view.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/pending_payments_pdf_view.dart';
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

class LedgerController extends GetxController with GetSingleTickerProviderStateMixin {
  GlobalKey<FormState> ledgerFormKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();

  RxBool isGenerateLoading = false.obs;

  RxList<get_parties.Data> partyList = <get_parties.Data>[].obs;
  RxString selectedParty = "".obs;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  TextEditingController searchPartyNameController = TextEditingController();
  RxBool isMonthlyLedgerLoading = false.obs;
  RxList<get_payment_ledger.GetPaymentLedgerModel> automaticLedgerList = RxList();
  RxList<get_payment_ledger.GetPaymentLedgerModel> searchAutomaticLedgerList = RxList();
  RxList<get_automatic_ledger_invoice.GetPartyData> automaticLedgerInvoiceList = RxList();
  RxList<get_automatic_ledger_invoice.GetPartyData> searchAutomaticLedgerInvoiceList = RxList();
  late TabController tabController;
  RxInt tabIndex = 0.obs;

  RxBool isGstFilteredParties = false.obs;

  Uint8List? upiQrImage;

  @override
  void onInit() {
    super.onInit();
    setQrImage();
    getPartiesApi();
    getAutomaticLedgerInvoiceApiCall();
    if (Get.arguments == true) {
      getAutomaticLedgerPaymentApiCall();
    }

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex(tabController.index);
    });
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

  void setQrImage() {
    final cleanedBase64 = AppConstance.cphUpiQrBase64.split(',').lastOrNull;
    if (cleanedBase64 != null) upiQrImage = base64Decode(cleanedBase64);
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

  Future<void> getAutomaticLedgerPaymentApiCall({bool isRefresh = false}) async {
    try {
      isMonthlyLedgerLoading(true);
      final response = await AccountServices.getAutomaticLedgerPaymentService();
      if (response.isSuccess) {
        get_automatic_ledger.GetAutomaticLedgerPaymentModel ledgerPaymentModel = get_automatic_ledger.GetAutomaticLedgerPaymentModel.fromJson(response.response?.data);
        automaticLedgerList.clear();
        searchAutomaticLedgerList.clear();
        automaticLedgerList.addAll(ledgerPaymentModel.data ?? []);
        searchAutomaticLedgerList.addAll(ledgerPaymentModel.data ?? []);
      }
    } finally {
      isMonthlyLedgerLoading(false);
    }
  }

  Future<void> getAutomaticLedgerInvoiceApiCall({bool isRefresh = false}) async {
    try {
      isMonthlyLedgerLoading(true);
      final response = await AccountServices.getAutomaticLedgerInvoiceService();
      if (response.isSuccess) {
        get_automatic_ledger_invoice.GetAutomaticLedgerInvoiceModel ledgerInvoiceModel = get_automatic_ledger_invoice.GetAutomaticLedgerInvoiceModel.fromJson(response.response?.data);
        automaticLedgerInvoiceList.clear();
        searchAutomaticLedgerInvoiceList.clear();
        automaticLedgerInvoiceList.addAll(ledgerInvoiceModel.data ?? []);
        searchAutomaticLedgerInvoiceList.addAll(ledgerInvoiceModel.data ?? []);
      }
    } finally {
      isMonthlyLedgerLoading(false);
    }
  }

  void searchParty(String value) {
    if (Get.arguments == true) {
      searchAutomaticLedgerList.clear();
      if (value.isNotEmpty) {
        searchAutomaticLedgerList.addAll(automaticLedgerList.where((element) => element.partyName?.toLowerCase().contains(value.toLowerCase()) == true && (isGstFilteredParties.isTrue ? element.isGst == true : true)).toList());
      } else {
        searchAutomaticLedgerList.addAll(automaticLedgerList.where((element) => isGstFilteredParties.isTrue ? element.isGst == true : true).toList());
      }
    } else {
      searchAutomaticLedgerInvoiceList.clear();
      if (value.isNotEmpty) {
        searchAutomaticLedgerInvoiceList.addAll(automaticLedgerInvoiceList.where((element) => element.partyName?.toLowerCase().contains(value.toLowerCase()) == true).toList());
      } else {
        searchAutomaticLedgerInvoiceList.addAll([...automaticLedgerInvoiceList]);
      }
    }
  }

  Future<void> generateLedgerApi({bool isPaymentLedger = false}) async {
    try {
      isGenerateLoading(true);
      if (ledgerFormKey.currentState?.validate() ?? false) {
        final response = isPaymentLedger
            ? await AccountServices.getLedgerPaymentService(
                startDate: DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy").parse(startDateController.text)),
                endDate: DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy").parse(endDateController.text)),
                partyId: selectedParty.value,
              )
            : await AccountServices.generateLedgerInvoiceService(
                startDate: DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy").parse(startDateController.text)),
                endDate: DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy").parse(endDateController.text)),
                partyId: selectedParty.value,
              );

        if (response.isSuccess) {
          if (isPaymentLedger) {
            get_payment_ledger.GetPaymentLedgerModel paymentLedgerModel = get_payment_ledger.GetPaymentLedgerModel.fromJson(response.response?.data);
            if (paymentLedgerModel.invoices?.isNotEmpty == true || paymentLedgerModel.payments?.isNotEmpty == true) {
              final ledgerResponse = await AccountServices.generateLedgerInvoiceService(
                startDate: DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy").parse(startDateController.text)),
                endDate: DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy").parse(endDateController.text)),
                partyId: selectedParty.value,
              );
              get_invoices.GetInvoicesModel invoicesModel = get_invoices.GetInvoicesModel.fromJson(ledgerResponse.response?.data ?? {});
              showInvoiceBottomSheet(
                ctx: Get.context!,
                ledgerInvoiceData: invoicesModel.data ?? [],
                paymentLedgerInvoiceData: paymentLedgerModel,
                isPaymentLedger: isPaymentLedger,
              );
            } else {
              Utils.handleMessage(message: AppStrings.noChallanAvailableYet.tr, isError: true);
            }
          } else {
            get_invoices.GetInvoicesModel invoicesModel = get_invoices.GetInvoicesModel.fromJson(response.response?.data);
            if (invoicesModel.data?.isNotEmpty == true) {
              showInvoiceBottomSheet(
                ctx: Get.context!,
                ledgerInvoiceData: invoicesModel.data ?? [],
                isPaymentLedger: isPaymentLedger,
              );
            } else {
              Utils.handleMessage(message: AppStrings.noChallanAvailableYet.tr, isError: true);
            }
          }
        }
      }
    } finally {
      isGenerateLoading(false);
    }
  }

  Future<void> showPendingPdfBottomSheet({
    required BuildContext ctx,
  }) async {
    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        return PendingPaymentsPdfView();
      },
    );
  }

  Future<void> showInvoiceBottomSheet({
    required BuildContext ctx,
    required List<get_invoices.OrderInvoice> ledgerInvoiceData,
    get_payment_ledger.GetPaymentLedgerModel? paymentLedgerInvoiceData,
    required bool isPaymentLedger,
    String? startDate,
    String? endDate,
  }) async {
    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        return LedgerInvoiceView(
          ledgerInvoiceData: ledgerInvoiceData,
          paymentLedgerInvoiceData: paymentLedgerInvoiceData,
          isPaymentLedger: isPaymentLedger,
          startDate: startDate,
          endDate: endDate,
        );
      },
    );
  }

  Future<File?> generateLedgerPdf({
    String? startDate,
    String? endDate,
    required String? selectedPartyId,
    required List<get_invoices.OrderInvoice> data,
    bool showAmount = false,
  }) async {
    final pdfDoc = pw.Document();

    final ttfRegular = pw.Font.ttf(await rootBundle.load(AppAssets.robotoRegular));
    final ttfBold = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBold));
    final ttfItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoItalic));
    final ttfBoldItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBoldItalic));
    final ttfNotoSansSymbols = pw.Font.ttf(await rootBundle.load(AppAssets.notoSansSymbols));

    pw.TextStyle size20Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.TextStyle size18Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.TextStyle size16Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.TextStyle size14Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.Widget TableCell({
      required String title,
    }) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: pw.Text(
          title,
          style: size14Font,
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
          style: size14Font,
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

    List<CategoryModel> getCategoryList(List<get_invoices.InvoiceMeta> invoiceMetaData) {
      List<CategoryModel> catModel = [];
      for (var element in invoiceMetaData) {
        if (catModel.any((e) => e.categoryId == element.categoryId)) {
          final catIndex = catModel.indexWhere((e) => e.categoryId == element.categoryId);
          catModel[catIndex] = catModel[catIndex].copyWith(
            categoryId: element.categoryId,
            categoryName: element.categoryName,
            categoryPrice: element.categoryPrice,
          );
        } else {
          catModel.add(
            CategoryModel(
              categoryId: element.categoryId,
              categoryName: element.categoryName,
              categoryPrice: element.categoryPrice,
            ),
          );
        }
      }
      for (int catIndex = 0; catIndex < catModel.length; catIndex++) {
        final invoiceMeta = invoiceMetaData.where((element) => element.categoryId == catModel[catIndex].categoryId).toList();
        catModel[catIndex] = catModel[catIndex].copyWith(
          totalInch: totalInchCount(invoiceMeta).toString(),
          totalAmount: totalAmountCount(invoiceMeta).toString(),
        );
      }
      return catModel;
    }

    List<CategoryModel> totalCategoriesOfLedger() {
      List<CategoryModel> catModel = [];
      for (int i = 0; i < data.length; i++) {
        final listOfCat = getCategoryList(data[i].invoiceMeta ?? []);
        for (int catIndex = 0; catIndex < listOfCat.length; catIndex++) {
          if (catModel.any((e) => e.categoryId == listOfCat[catIndex].categoryId)) {
            final currIndex = catModel.indexWhere((e) => e.categoryId == listOfCat[catIndex].categoryId);
            catModel[currIndex] = catModel[currIndex].copyWith(
              totalInch: ((catModel[currIndex].totalInch?.toDouble() ?? 0.0) + (listOfCat[catIndex].totalInch?.toDouble() ?? 0.0)).toString(),
              totalAmount: ((catModel[currIndex].totalAmount?.toDouble() ?? 0.0) + (listOfCat[catIndex].totalAmount?.toDouble() ?? 0.0)).toString(),
            );
          } else {
            catModel.add(listOfCat[catIndex]);
          }
        }
      }
      return catModel;
    }

    pw.PageTheme? pdfPageTheme = pw.PageTheme(
      pageFormat: pdf.PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      theme: pw.ThemeData.withFont(
        base: ttfRegular,
        bold: ttfBold,
        italic: ttfItalic,
        boldItalic: ttfBoldItalic,
        icons: ttfBold,
        fontFallback: [
          ttfNotoSansSymbols,
        ],
      ),
    );

    pdfDoc.addPage(
      pw.MultiPage(
        pageTheme: pdfPageTheme,
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
                      "${AppStrings.date.tr}: ${startDate ?? startDateController.text} - ${endDate ?? endDateController.text}",
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
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
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
                        width: 30,
                        child: TableHeadingCell(title: AppStrings.sr.tr.replaceAll(".", "")),
                      ),

                      /// Category
                      pw.SizedBox(
                        width: 52,
                        child: TableHeadingCell(title: AppStrings.cat.tr),
                      ),

                      /// In Date
                      pw.SizedBox(
                        width: 70,
                        child: TableHeadingCell(title: AppStrings.inDate.tr),
                      ),

                      /// PVD Color
                      pw.SizedBox(
                        width: 60,
                        child: TableHeadingCell(title: AppStrings.pvdColor.tr),
                      ),

                      /// Item
                      TableHeadingCell(title: AppStrings.item.tr),

                      /// Inch
                      pw.SizedBox(
                        width: 32,
                        child: TableHeadingCell(title: AppStrings.inch.tr),
                      ),

                      /// QTY
                      pw.SizedBox(
                        width: 42,
                        child: TableHeadingCell(title: AppStrings.qty.tr),
                      ),

                      /// Previous
                      pw.SizedBox(
                        width: 42,
                        child: TableHeadingCell(title: AppStrings.previous.tr),
                      ),

                      /// OK
                      pw.SizedBox(
                        width: 42,
                        child: TableHeadingCell(title: AppStrings.ok.tr),
                      ),

                      /// W/O
                      pw.SizedBox(
                        width: 32,
                        child: TableHeadingCell(title: AppStrings.wo.tr),
                      ),

                      /// Total Inch
                      pw.SizedBox(
                        width: 52,
                        child: TableHeadingCell(title: AppStrings.totalInch.tr.replaceAll("C1 ", "")),
                      ),

                      /// Balance QTY
                      pw.SizedBox(
                        width: 42,
                        child: TableHeadingCell(title: AppStrings.balanceQTY.tr),
                      ),

                      if (showAmount) ...[
                        /// Price
                        pw.SizedBox(
                          width: 32,
                          child: TableCell(title: AppStrings.pr.tr),
                        ),

                        /// Total Amount
                        TableHeadingCell(title: AppStrings.totalAmount.tr.replaceAll("C1 ", "")),
                      ],
                    ],
                  ),

                  for (int i = 0; i < (data[invoiceIndex].invoiceMeta?.length ?? 0); i++) ...[
                    (() {
                      final invoice = data[invoiceIndex].invoiceMeta?[i];
                      return pw.TableRow(
                        children: [
                          /// SR.
                          pw.SizedBox(
                            width: 30,
                            child: TableCell(title: NumberFormat("00").format("${i + 1}".toInt())),
                          ),

                          /// Category
                          pw.SizedBox(
                            width: 52,
                            child: TableCell(title: invoice?.categoryName ?? ""),
                          ),

                          /// In Date
                          pw.SizedBox(
                            width: 70,
                            child: TableCell(title: DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(invoice?.inDate ?? ""))),
                          ),

                          /// PVD Color
                          pw.SizedBox(
                            width: 60,
                            child: TableCell(title: invoice?.pvdColor ?? ""),
                          ),

                          /// Item
                          TableCell(title: invoice?.itemName ?? ""),

                          /// Inch
                          pw.SizedBox(
                            width: 32,
                            child: TableCell(title: invoice?.inch ?? ""),
                          ),

                          /// QTY
                          pw.SizedBox(
                            width: 42,
                            child: TableCell(title: invoice?.quantity ?? ""),
                          ),

                          /// Previous
                          pw.SizedBox(
                            width: 42,
                            child: TableCell(title: invoice?.previous ?? ""),
                          ),

                          /// OK
                          pw.SizedBox(
                            width: 42,
                            child: TableCell(title: invoice?.okPcs ?? ""),
                          ),

                          /// W/O
                          pw.SizedBox(
                            width: 32,
                            child: TableCell(title: invoice?.woProcess ?? ""),
                          ),

                          /// Total Inch
                          pw.SizedBox(
                            width: 52,
                            child: TableCell(title: invoice?.totalInch ?? ""),
                          ),

                          /// Balance QTY
                          pw.SizedBox(
                            width: 42,
                            child: TableCell(title: invoice?.balanceQuantity ?? ""),
                          ),

                          if (showAmount) ...[
                            /// Price
                            pw.SizedBox(
                              width: 32,
                              child: TableCell(title: "₹${invoice?.categoryPrice ?? ""}"),
                            ),

                            /// Total Amount
                            TableCell(
                              title: invoice?.totalAmount != null && invoice?.totalAmount?.isNotEmpty == true ? NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(invoice?.totalAmount!.toDouble()) : "",
                            ),
                          ],
                        ],
                      );
                    })(),
                  ],
                ],
              ),
              pw.SizedBox(height: 8),

              /// Total Inch By Category
              if (!showAmount) ...[
                for (int categoryIndex = 0; categoryIndex < getCategoryList(data[invoiceIndex].invoiceMeta ?? []).length; categoryIndex++) ...[
                  (() {
                    final category = getCategoryList(data[invoiceIndex].invoiceMeta ?? [])[categoryIndex];
                    return pw.Row(
                      children: [
                        pw.Text(
                          "${AppStrings.totalInch.tr.replaceAll("C1", category.categoryName ?? '')}: ",
                          style: size16Font.copyWith(fontSize: 18),
                        ),
                        pw.Text(
                          category.totalInch ?? "",
                          style: size16Font.copyWith(fontSize: 18),
                        ),
                      ],
                    );
                  })(),
                  pw.SizedBox(height: 3),
                ],
              ],
              if (showAmount) ...[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "${AppStrings.totalAmount.tr.replaceAll("C1 ", "")}: ",
                      style: size16Font.copyWith(fontSize: 18),
                    ),
                    pw.Text(
                      NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(totalAmountCount(data[invoiceIndex].invoiceMeta ?? [])),
                      style: size16Font.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ],
              pw.SizedBox(height: 30),
            ],
          ];
        },
      ),
    );

    /// Mega Total of Inch & Amount Table
    pdfDoc.addPage(
      pw.MultiPage(
        pageTheme: pdfPageTheme,
        build: (context) {
          return <pw.Widget>[
            /// Mega Total Title
            pw.Center(
              child: pw.RichText(
                text: pw.TextSpan(
                  text: "❖",
                  children: [
                    pw.TextSpan(
                      text: " ${AppStrings.totalAssetsCalculation.tr} ",
                      style: size20Font.copyWith(
                        fontSize: 22,
                        font: ttfRegular,
                        fontNormal: ttfRegular,
                        fontBold: ttfBold,
                      ),
                    ),
                    pw.TextSpan(
                      text: "❖",
                    ),
                  ],
                  style: size20Font.copyWith(font: ttfNotoSansSymbols),
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            if (data.isNotEmpty) ...[
              pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
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

                      if (!showAmount) ...[
                        /// Category Name
                        TableCell(title: AppStrings.category.tr),

                        /// Mega Total Inch
                        TableCell(title: AppStrings.totalInch.tr.replaceAll("C1 ", "")),
                      ],

                      /// Mega Total Amount
                      if (showAmount) TableCell(title: AppStrings.totalAmount.tr.replaceAll("C1 ", "")),
                    ],
                  ),

                  ///Data
                  for (int i = 0; i < data.length; i++) ...[
                    if (!showAmount) ...[
                      for (int catIndex = 0; catIndex < getCategoryList(data[i].invoiceMeta ?? []).length; catIndex++) ...[
                        (() {
                          final category = getCategoryList(data[i].invoiceMeta ?? [])[catIndex];
                          return pw.TableRow(
                            children: [
                              /// Challan Number
                              if (catIndex == 0) ...[
                                pw.TableCell(
                                  rowSpan: getCategoryList(data[i].invoiceMeta ?? []).length,
                                  child: TableCell(title: data[i].challanNumber ?? ""),
                                ),
                              ],

                              /// Category Name
                              TableCell(
                                title: category.categoryName ?? "",
                              ),

                              /// Mega Total Inch
                              TableCell(
                                title: category.totalInch ?? "",
                              ),
                            ],
                          );
                        })(),
                      ],
                    ] else ...[
                      pw.TableRow(
                        children: [
                          /// Challan Number
                          TableCell(title: data[i].challanNumber ?? ""),

                          /// Mega Total Amount
                          TableCell(
                            title: NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(
                              totalAmountCount(data[i].invoiceMeta ?? []),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],

                  ///Calculation Row
                  if (!showAmount) ...[
                    for (int catIndex = 0; catIndex < totalCategoriesOfLedger().length; catIndex++) ...[
                      (() {
                        final category = totalCategoriesOfLedger()[catIndex];
                        return pw.TableRow(
                          children: [
                            /// Total Inch Categories
                            if (catIndex == 0) ...[
                              pw.TableCell(
                                rowSpan: totalCategoriesOfLedger().length,
                                child: TableCell(
                                  title: AppStrings.totalInchCategories.tr,
                                ),
                              ),
                            ],

                            /// Category Name
                            TableCell(
                              title: category.categoryName ?? "",
                            ),

                            /// Mega Total Inch
                            TableCell(
                              title: category.totalInch ?? "",
                            ),

                            /// Mega Total Amount
                            if (showAmount)
                              TableCell(
                                title: NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(
                                  category.totalAmount?.toDouble() ?? 0.0,
                                ),
                              ),
                          ],
                        );
                      })(),
                    ],
                  ] else ...[
                    pw.TableRow(
                      children: [
                        /// Total Amount
                        TableCell(
                          title: AppStrings.totalAmount.tr.replaceAll("C1 ", ""),
                        ),

                        /// Mega Total Inch
                        TableCell(
                          title: NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(megaTotalAmountCount()),
                        ),
                      ],
                    ),
                  ],
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
      final fileName = 'Ledger_${partyList.firstWhereOrNull((element) => element.orderId == (selectedPartyId ?? selectedParty.value))?.partyName ?? ""}_${startDate ?? startDateController.text}_${endDate ?? endDateController.text}'.cleanFileName;
      final file = File('${dir.path}/$fileName.pdf');
      final fileBytes = await pdfDoc.save();
      return await file.writeAsBytes(fileBytes);
    }
    return null;
  }

  Future<File?> generatePaymentLedgerPdf({
    required get_payment_ledger.GetPaymentLedgerModel data,
    bool showAmount = false,
  }) async {
    final pdfDoc = pw.Document();

    final ttfRegular = pw.Font.ttf(await rootBundle.load(AppAssets.robotoRegular));
    final ttfBold = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBold));
    final ttfItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoItalic));
    final ttfBoldItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBoldItalic));
    final ttfNotoSansSymbols = pw.Font.ttf(await rootBundle.load(AppAssets.notoSansSymbols));

    pw.TextStyle size20Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.TextStyle size16Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.TextStyle size14Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 14,
      fontWeight: pw.FontWeight.normal,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.PageTheme? pdfPageTheme = pw.PageTheme(
      pageFormat: pdf.PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      theme: pw.ThemeData.withFont(
        base: ttfRegular,
        bold: ttfBold,
        italic: ttfItalic,
        boldItalic: ttfBoldItalic,
        icons: ttfBold,
        fontFallback: [
          ttfNotoSansSymbols,
        ],
      ),
    );

    pdfDoc.addPage(
      pw.MultiPage(
        pageTheme: pdfPageTheme,
        maxPages: 1000,
        footer: (context) {
          if (context.pageNumber == context.pagesCount) {
            return pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 10),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  ///Summary
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.SizedBox(
                        width: (pdfPageTheme.pageFormat.width / 2) * 0.4,
                        child: pw.DecoratedBox(
                          decoration: pw.BoxDecoration(
                            border: pw.Border(
                              top: pw.BorderSide(
                                width: 1,
                                color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                              ),
                              bottom: pw.BorderSide(
                                width: 1,
                                color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                              ),
                            ),
                          ),
                          child: pw.Padding(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                /// Total Payment
                                pw.Text(
                                  data.summary?.totalPaymentAmount?.toString() ?? "",
                                  style: size14Font.copyWith(fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(height: 3),

                                /// Pending Amount
                                pw.Text(
                                  data.summary?.pendingAmount?.toString() ?? "",
                                  style: size14Font.copyWith(fontWeight: pw.FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Padding(
                        padding: pw.EdgeInsets.symmetric(vertical: 5),
                        child: pw.Text(
                          "DB ${AppStrings.closingBalance.tr}",
                          style: size14Font.copyWith(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  /// Total Invoice
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: pdfPageTheme.pageFormat.width / 2,
                        child: pw.Row(
                          children: [
                            pw.SizedBox(
                              width: (pdfPageTheme.pageFormat.width / 2) * 0.4,
                              child: pw.DecoratedBox(
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    bottom: pw.BorderSide(
                                      width: 1,
                                      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                                    ),
                                  ),
                                ),
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.symmetric(vertical: 5),
                                  child: pw.Text(
                                    data.summary?.totalInvoiceAmount?.toString() ?? "",
                                    textAlign: pw.TextAlign.end,
                                    style: size14Font.copyWith(fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(
                        width: pdfPageTheme.pageFormat.width / 2,
                        child: pw.Row(
                          children: [
                            pw.SizedBox(
                              width: (pdfPageTheme.pageFormat.width / 2) * 0.4,
                              child: pw.DecoratedBox(
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    top: pw.BorderSide(
                                      width: 1,
                                      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                                    ),
                                    bottom: pw.BorderSide(
                                      width: 1,
                                      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                                    ),
                                  ),
                                ),
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.symmetric(vertical: 5),
                                  child: pw.Text(
                                    data.summary?.totalInvoiceAmount?.toString() ?? "",
                                    textAlign: pw.TextAlign.end,
                                    style: size14Font.copyWith(fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return pw.SizedBox.shrink();
        },
        build: (context) {
          return <pw.Widget>[
            /// Ledger Title
            if (data.invoices?.isNotEmpty == true || data.payments?.isNotEmpty == true) ...[
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Text(
                  "CPH",
                  style: size20Font,
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  /// Party Name
                  pw.Text(
                    "${AppStrings.partyName.tr}: ${data.partyName ?? ""}",
                    style: size16Font,
                  ),
                  pw.SizedBox(height: 3),

                  /// Date Range
                  pw.Text(
                    "${AppStrings.date.tr}: ${data.startDate != null && data.startDate?.isNotEmpty == true ? DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(data.startDate!)) : startDateController.text} - ${data.endDate != null && data.endDate?.isNotEmpty == true ? DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(data.endDate!)) : endDateController.text}",
                    style: size16Font,
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
            ],

            ///Headings
            pw.DecoratedBox(
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(
                    width: 1,
                    color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                  ),
                  bottom: pw.BorderSide(
                    width: 1,
                    color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                  ),
                ),
              ),
              child: pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: pw.Row(
                  children: [
                    /// Payments
                    pw.SizedBox(
                      width: pdfPageTheme.pageFormat.width / 2,
                      child: pw.Text(
                        AppStrings.payments.tr,
                        textAlign: pw.TextAlign.center,
                        style: size16Font,
                      ),
                    ),

                    /// Invoices
                    pw.SizedBox(
                      width: pdfPageTheme.pageFormat.width / 2,
                      child: pw.Text(
                        AppStrings.invoices.tr,
                        textAlign: pw.TextAlign.center,
                        style: size16Font,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 10),

            pw.Table(
              columnWidths: {
                0: pw.FixedColumnWidth(pdfPageTheme.pageFormat.width / 2),
                1: pw.FixedColumnWidth(pdfPageTheme.pageFormat.width / 2),
              },
              children: [
                /// Opening Balance
                pw.TableRow(
                  children: [
                    pw.SizedBox(
                      width: pdfPageTheme.pageFormat.width / 2,
                    ),
                    pw.SizedBox(
                      width: pdfPageTheme.pageFormat.width / 2,
                      child: pw.Row(
                        mainAxisSize: pw.MainAxisSize.max,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.SizedBox(
                            width: (pdfPageTheme.pageFormat.width / 2) * 0.4,
                            child: pw.Text(
                              data.summary?.openingAmount?.toString() ?? "0.0",
                              textAlign: pw.TextAlign.end,
                              style: size14Font.copyWith(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.SizedBox(
                            width: (pdfPageTheme.pageFormat.width / 2) * 0.6,
                            child: pw.Text(
                              "DB ${AppStrings.openingBalance.tr}",
                              textAlign: pw.TextAlign.start,
                              style: size14Font.copyWith(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.SizedBox(
                      width: pdfPageTheme.pageFormat.width / 2,
                    ),
                    pw.SizedBox(height: 8),
                  ],
                ),

                /// Payments & Invoices Data
                for (int rowIndex = 0; rowIndex < ((data.invoices?.length ?? 0) > (data.payments?.length ?? 0) ? (data.invoices?.length ?? 0) : (data.payments?.length ?? 0)); rowIndex++) ...[
                  pw.TableRow(
                    children: [
                      if (rowIndex < (data.payments?.length ?? 0)) ...[
                        /// Payments
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(
                              width: (pdfPageTheme.pageFormat.width / 2) * 0.4,
                              child: pw.Text(
                                data.payments?[rowIndex].amount?.toString() ?? "",
                                textAlign: pw.TextAlign.end,
                                style: size14Font,
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.SizedBox(
                              width: (pdfPageTheme.pageFormat.width / 2) * 0.6,
                              child: pw.Text(
                                data.payments?[rowIndex].createdDate?.isNotEmpty == true ? DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(data.payments?[rowIndex].createdDate ?? "")) : "",
                                textAlign: pw.TextAlign.start,
                                style: size14Font,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                          height: 3,
                        ),
                      ],

                      if (rowIndex < (data.invoices?.length ?? 0)) ...[
                        /// Invoices
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.SizedBox(
                              width: (pdfPageTheme.pageFormat.width / 2) * 0.4,
                              child: pw.Text(
                                data.invoices?[rowIndex].totalAmount?.toString() ?? "",
                                textAlign: pw.TextAlign.end,
                                style: size14Font,
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.SizedBox(
                              width: (pdfPageTheme.pageFormat.width / 2) * 0.6,
                              child: pw.Text(
                                data.invoices?[rowIndex].challanNumber ?? "",
                                textAlign: pw.TextAlign.start,
                                style: size14Font,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                          height: 3,
                        ),
                      ],
                    ],
                  ),

                  ///Discount
                  if (data.payments?[rowIndex].discount != null && data.payments?[rowIndex].discount != 0.0) ...[
                    pw.TableRow(
                      children: [
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                          height: 3,
                        ),
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                          height: 3,
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                          child: pw.Text(
                            "${data.payments?[rowIndex].discount?.toString() ?? "0.0"} off",
                            textAlign: pw.TextAlign.center,
                            style: size14Font,
                          ),
                        ),
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                        ),
                      ],
                    ),
                  ],

                  pw.TableRow(
                    children: [
                      pw.SizedBox(
                        width: pdfPageTheme.pageFormat.width / 2,
                        height: 3,
                      ),
                      pw.SizedBox(
                        width: pdfPageTheme.pageFormat.width / 2,
                        height: 3,
                      ),
                    ],
                  ),

                  pw.TableRow(
                    children: [
                      /// Payment Mode
                      if (rowIndex < (data.payments?.length ?? 0)) ...[
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                          child: pw.Text(
                            data.payments?[rowIndex].paymentMode ?? "",
                            textAlign: pw.TextAlign.center,
                            style: size14Font,
                          ),
                        ),
                      ] else ...[
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                        ),
                      ],

                      /// Invoice Date
                      if (rowIndex < (data.invoices?.length ?? 0)) ...[
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                          child: pw.Text(
                            data.invoices?[rowIndex].createdDate?.isNotEmpty == true ? DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(data.invoices?[rowIndex].createdDate ?? "")) : "",
                            textAlign: pw.TextAlign.center,
                            style: size14Font,
                          ),
                        ),
                      ] else ...[
                        pw.SizedBox(
                          width: pdfPageTheme.pageFormat.width / 2,
                        ),
                      ],
                    ],
                  ),

                  pw.TableRow(
                    children: [
                      pw.SizedBox(
                        width: pdfPageTheme.pageFormat.width / 2,
                        height: 10,
                      ),
                      pw.SizedBox(
                        width: pdfPageTheme.pageFormat.width / 2,
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ];
        },
      ),
    );

    final status = await Utils.getDashboardController.permissionStatus();
    if (status.$1.isGranted || status.$2.isGranted) {
      final dir = await getApplicationCacheDirectory();
      final fileName = 'Payment_Ledger_${partyList.firstWhereOrNull((element) => element.orderId == data.partyId)?.partyName ?? ""}_${data.startDate}_${data.endDate}'.cleanFileName;
      final file = File('${dir.path}/$fileName.pdf');
      final fileBytes = await pdfDoc.save();
      return await file.writeAsBytes(fileBytes);
    }
    return null;
  }

  Future<File?> generatePendingPaymentsPdf({
    required String mode,
  }) async {
    final pdfDoc = pw.Document();

    final ttfRegular = pw.Font.ttf(await rootBundle.load(AppAssets.robotoRegular));
    final ttfBold = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBold));
    final ttfItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoItalic));
    final ttfBoldItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBoldItalic));
    final ttfNotoSansSymbols = pw.Font.ttf(await rootBundle.load(AppAssets.notoSansSymbols));

    pw.TextStyle size20Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.TextStyle size14Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 14,
      fontWeight: pw.FontWeight.normal,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.PageTheme? pdfPageTheme = pw.PageTheme(
      pageFormat: pdf.PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      theme: pw.ThemeData.withFont(
        base: ttfRegular,
        bold: ttfBold,
        italic: ttfItalic,
        boldItalic: ttfBoldItalic,
        icons: ttfBold,
        fontFallback: [
          ttfNotoSansSymbols,
        ],
      ),
    );

    pdfDoc.addPage(
      pw.MultiPage(
        pageTheme: pdfPageTheme,
        build: (context) {
          return <pw.Widget>[
            /// Title
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Text(
                AppStrings.pendingPayment.tr,
                style: size20Font,
              ),
            ),
            pw.SizedBox(height: 10),

            pw.Table(
              columnWidths: {
                0: pw.FixedColumnWidth((pdfPageTheme.pageFormat.width / 3.5) - 10),
                1: pw.FixedColumnWidth((pdfPageTheme.pageFormat.width / 3.5) - 10),
                2: pw.FixedColumnWidth((pdfPageTheme.pageFormat.width / 3.5) - 10),
                3: pw.FixedColumnWidth((pdfPageTheme.pageFormat.width / 6) - 10),
              },
              border: pw.TableBorder.all(
                width: 1,
                color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
              ),
              children: [
                ///Headings
                pw.TableRow(
                  children: [
                    /// Party
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: pw.Text(
                        AppStrings.party.tr,
                        textAlign: pw.TextAlign.center,
                        style: size14Font,
                      ),
                    ),

                    /// Phone Number
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: pw.Text(
                        AppStrings.phoneNumber.tr,
                        textAlign: pw.TextAlign.center,
                        style: size14Font,
                      ),
                    ),

                    /// Pending Payment
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: pw.Text(
                        AppStrings.pendingAmount.tr,
                        textAlign: pw.TextAlign.center,
                        style: size14Font,
                      ),
                    ),

                    /// Remark
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: pw.Text(
                        AppStrings.remark.tr,
                        textAlign: pw.TextAlign.center,
                        style: size14Font,
                      ),
                    ),
                  ],
                ),

                /// Data
                for (int rowIndex = 0; rowIndex < searchAutomaticLedgerList.length; rowIndex++) ...[
                  pw.TableRow(
                    children: [
                      /// Party
                      pw.Padding(
                        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: pw.Text(
                          searchAutomaticLedgerList[rowIndex].partyName ?? "",
                          textAlign: pw.TextAlign.start,
                          style: size14Font,
                        ),
                      ),

                      /// Phone Number
                      pw.Padding(
                        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: pw.Text(
                          searchAutomaticLedgerList[rowIndex].phoneNumber ?? "",
                          textAlign: pw.TextAlign.start,
                          style: size14Font,
                        ),
                      ),

                      /// Pending Payment
                      pw.Padding(
                        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: pw.Text(
                          searchAutomaticLedgerList[rowIndex].summary?.pendingAmount != null ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(searchAutomaticLedgerList[rowIndex].summary?.pendingAmount) : "",
                          textAlign: pw.TextAlign.start,
                          style: size14Font,
                        ),
                      ),

                      /// Remark
                      pw.Padding(
                        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: pw.SizedBox(),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ];
        },
      ),
    );

    final status = await Utils.getDashboardController.permissionStatus();
    if (status.$1.isGranted || status.$2.isGranted) {
      final dir = await getApplicationCacheDirectory();
      final fileName = 'Pending_Payments_PartyWise_${DateTime.now().millisecondsSinceEpoch}'.cleanFileName;
      final file = File('${dir.path}/$fileName.pdf');
      final fileBytes = await pdfDoc.save();
      return await file.writeAsBytes(fileBytes);
    }
    return null;
  }
}

class CategoryModel {
  String? categoryId;
  String? categoryName;
  String? categoryPrice;
  String? totalInch;
  String? totalAmount;

  CategoryModel({
    this.categoryId,
    this.categoryName,
    this.categoryPrice,
    this.totalInch,
    this.totalAmount,
  });

  CategoryModel copyWith({
    String? categoryId,
    String? categoryName,
    String? categoryPrice,
    String? totalInch,
    String? totalAmount,
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryPrice: categoryPrice ?? this.categoryPrice,
      totalInch: totalInch ?? this.totalInch,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

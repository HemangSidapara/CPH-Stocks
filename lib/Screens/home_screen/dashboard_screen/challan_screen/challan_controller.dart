import 'dart:io';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart' as get_invoices;
import 'package:cph_stocks/Network/services/challan_services/challan_service.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class ChallanController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<get_invoices.OrderInvoice> searchedInvoiceList = RxList();
  RxList<get_invoices.OrderInvoice> invoiceList = RxList();
  RxBool isGetInvoicesLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getInvoicesApi();
  }

  Future<void> getInvoicesApi({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetInvoicesLoading(isLoading);
      final response = await ChallanService.getInvoicesService();

      if (response.isSuccess) {
        get_invoices.GetInvoicesModel invoicesModel = get_invoices.GetInvoicesModel.fromJson(response.response?.data);
        invoiceList.clear();
        searchedInvoiceList.clear();
        invoiceList.addAll(invoicesModel.data ?? []);
        searchedInvoiceList.addAll(invoicesModel.data ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetInvoicesLoading(false);
    }
  }

  Future<void> searchPartyName(String searchedValue) async {
    searchedInvoiceList.clear();
    if (searchedValue.isNotEmpty) {
      searchedInvoiceList.addAll(invoiceList.where((element) => element.partyName?.toLowerCase().contains(searchedValue.toLowerCase()) == true));
    } else {
      searchedInvoiceList.addAll(invoiceList);
    }
  }

  /// @function generatePdf
  /// @description generate pdf from data
  /// @param {List\<get_invoices.InvoiceMeta>} data - List of invoice data
  /// @param {String} partyName - Party name
  /// @param {String} challanNumber - Challan number
  /// @param {String} createdDate - Created date
  /// @returns {Future\<File?>} - Returns a Future of a File object
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<File?> generatePdf({
    required String partyName,
    required String challanNumber,
    required String createdDate,
    bool isLandscape = true,
    required List<get_invoices.InvoiceMeta> data,
    bool showAmount = false,
  }) async {
    final pdfDoc = pw.Document();

    pw.TextStyle size22Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: isLandscape ? 14 : 22,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle size16Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: isLandscape ? 10 : 16,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle size12Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: isLandscape ? 9.5 : 12,
      fontWeight: pw.FontWeight.bold,
    );

    pw.Widget TableCell({
      required String title,
    }) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: isLandscape ? 3 : 5, vertical: isLandscape ? 2.5 : 5),
        child: pw.Text(
          title,
          style: size16Font,
        ),
      );
    }

    pw.Widget TableHeadingCell({
      required String title,
    }) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: isLandscape ? 3 : 5, vertical: 1.5),
        child: pw.Text(
          title,
          style: size12Font,
        ),
      );
    }

    double totalAmountCount({List<get_invoices.InvoiceMeta>? invoiceMeta}) {
      final listOfAmounts = (invoiceMeta ?? data).where((element) => element.totalAmount != null && element.totalAmount?.isNotEmpty == true).toList().map((e) => e.totalAmount!.toDouble()).toList();
      return listOfAmounts.isNotEmpty ? listOfAmounts.reduce((value, element) => value + element) : 0.0;
    }

    double totalInchCount({List<get_invoices.InvoiceMeta>? invoiceMeta}) {
      final listOfInch = (invoiceMeta ?? data).where((element) => element.totalInch != null && element.totalInch?.isNotEmpty == true).toList().map((e) => e.totalInch!.toDouble()).toList();
      return listOfInch.isNotEmpty ? listOfInch.reduce((value, element) => value + element) : 0.0;
    }

    List<CategoryModel> getCategoryList() {
      List<CategoryModel> catModel = [];
      for (var element in data) {
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
        final invoiceMeta = data.where((element) => element.categoryId == catModel[catIndex].categoryId).toList();
        catModel[catIndex] = catModel[catIndex].copyWith(
          totalInch: totalInchCount(invoiceMeta: invoiceMeta).toString(),
          totalAmount: totalAmountCount(invoiceMeta: invoiceMeta).toString(),
        );
      }
      return catModel;
    }

    final ttfRegular = pw.Font.ttf(await rootBundle.load(AppAssets.robotoRegular));
    final ttfBold = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBold));
    final ttfItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoItalic));
    final ttfBoldItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBoldItalic));

    pdfDoc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pdf.PdfPageFormat.a5,
          orientation: isLandscape ? pw.PageOrientation.landscape : pw.PageOrientation.portrait,
          margin: pw.EdgeInsets.symmetric(horizontal: isLandscape ? 8 : 15, vertical: isLandscape ? 5 : 10),
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
            /// Title
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                /// Party Name
                pw.ConstrainedBox(
                  constraints: pw.BoxConstraints(maxWidth: isLandscape ? 250 : 350),
                  child: pw.Text(
                    partyName,
                    style: size22Font,
                  ),
                ),

                /// Challan Number
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: isLandscape ? 5.33 : 10),
                  child: pw.Text(
                    challanNumber,
                    style: size22Font,
                  ),
                ),

                /// Created Date
                pw.Text(
                  "${AppStrings.date.tr}: ${DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(createdDate))}",
                  style: size22Font,
                ),
              ],
            ),
            pw.SizedBox(height: isLandscape ? 5 : 10),

            /// Invoice Table
            pw.Table(
              border: pw.TableBorder.all(
                color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                width: 1.2,
              ),
              children: [
                /// Header
                pw.TableRow(
                  children: [
                    /// SR.
                    pw.SizedBox(
                      width: isLandscape ? 20 : 38,
                      child: TableHeadingCell(title: AppStrings.sr.tr),
                    ),

                    /// Category
                    pw.SizedBox(
                      width: isLandscape ? 50 : 85,
                      child: TableHeadingCell(title: AppStrings.category.tr),
                    ),

                    /// PVD Color
                    TableHeadingCell(title: AppStrings.pvdColor.tr),

                    /// Item
                    pw.SizedBox(
                      width: isLandscape ? 65 : 110,
                      child: TableHeadingCell(title: AppStrings.item.tr),
                    ),

                    /// In Date
                    pw.SizedBox(
                      width: isLandscape ? 55 : 88,
                      child: TableHeadingCell(title: AppStrings.inDate.tr),
                    ),

                    /// QTY
                    TableHeadingCell(title: AppStrings.qty.tr),

                    /// Previous
                    TableHeadingCell(title: AppStrings.previous.tr),

                    /// OK
                    TableHeadingCell(title: AppStrings.ok.tr),

                    /// W/O
                    TableHeadingCell(title: AppStrings.wo.tr),

                    /// Inch
                    TableHeadingCell(title: AppStrings.inch.tr),

                    /// Total Inch
                    TableHeadingCell(title: AppStrings.totalInch.tr.replaceAll("C1 ", "")),

                    /// Balance QTY
                    TableHeadingCell(title: AppStrings.balanceQTY.tr),

                    /// Total Amount
                    if (showAmount) TableHeadingCell(title: AppStrings.totalAmount.tr.replaceAll("C1 ", "")),
                  ],
                ),

                for (int i = 0; i < data.length; i++) ...[
                  pw.TableRow(
                    children: [
                      /// SR.
                      pw.SizedBox(
                        width: isLandscape ? 20 : 38,
                        child: TableCell(title: NumberFormat("00").format(i + 1)),
                      ),

                      /// Category
                      pw.SizedBox(
                        width: isLandscape ? 50 : 85,
                        child: TableCell(title: data[i].categoryName ?? ""),
                      ),

                      /// PVD Color
                      TableCell(title: data[i].pvdColor ?? ""),

                      /// Item
                      pw.SizedBox(
                        width: isLandscape ? 65 : 110,
                        child: TableCell(title: data[i].itemName ?? ""),
                      ),

                      /// In Date
                      pw.SizedBox(
                        width: isLandscape ? 55 : 88,
                        child: TableCell(title: DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(data[i].inDate ?? ""))),
                      ),

                      /// QTY
                      TableCell(title: data[i].quantity ?? ""),

                      /// Previous
                      TableCell(title: data[i].previous ?? ""),

                      /// OK
                      TableCell(title: data[i].okPcs ?? ""),

                      /// W/O
                      TableCell(title: data[i].woProcess ?? ""),

                      /// Inch
                      TableCell(title: data[i].inch ?? ""),

                      /// Total Inch
                      TableCell(title: data[i].totalInch ?? ""),

                      /// Balance QTY
                      TableCell(title: data[i].balanceQuantity ?? ""),

                      /// Total Amount
                      if (showAmount) TableCell(title: data[i].totalAmount != null && data[i].totalAmount?.isNotEmpty == true ? NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(data[i].totalAmount!.toDouble()) : ""),
                    ],
                  ),
                ],
              ],
            ),
            pw.SizedBox(height: isLandscape ? 5 : 10),

            /// Total Inch By Category
            if (!showAmount) ...[
              for (int categoryIndex = 0; categoryIndex < getCategoryList().length; categoryIndex++) ...[
                (() {
                  final category = getCategoryList()[categoryIndex];
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        "${AppStrings.totalInch.tr.replaceAll("C1", category.categoryName ?? '')}: ",
                        style: size16Font.copyWith(fontSize: 12),
                      ),
                      pw.Text(
                        category.totalInch ?? "",
                        style: size16Font.copyWith(fontSize: 12),
                      ),
                    ],
                  );
                })(),
                pw.SizedBox(height: isLandscape ? 2 : 3),
              ],
            ],

            ///Total Amount
            if (showAmount) ...[
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "${AppStrings.totalAmount.tr.replaceAll("C1 ", "")}: ",
                    style: size16Font.copyWith(fontSize: 12),
                  ),
                  pw.Text(
                    NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(totalAmountCount()),
                    style: size16Font.copyWith(fontSize: 12),
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
      final fileName = '${partyName}_${challanNumber}_$createdDate'.cleanFileName;
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

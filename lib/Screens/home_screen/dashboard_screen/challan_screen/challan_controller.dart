import 'dart:io';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart' as get_invoices;
import 'package:cph_stocks/Network/services/challan_services/challan_service.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChallanController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<get_invoices.OrderInvoice> searchedInvoiceList = RxList();
  RxList<get_invoices.OrderInvoice> invoiceList = RxList();
  RxBool isGetInvoicesLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  RxBool deletingInvoicesEnable = false.obs;
  RxList<String> selectedInvoices = RxList();
  RxBool isDeleteInvoicesLoading = false.obs;

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

  Future<void> deleteInvoicesApiCall() async {
    try {
      isDeleteInvoicesLoading(true);
      final response = await ChallanService.deleteInvoicesService(orderInvoiceIds: selectedInvoices);
      if (response.isSuccess) {
        await getInvoicesApi(isLoading: false);
        Get.back();
        Utils.handleMessage(message: response.message);
      }
    } finally {
      isDeleteInvoicesLoading(false);
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

    final ttfRegular = pw.Font.ttf(await rootBundle.load(AppAssets.robotoRegular));
    final ttfBold = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBold));
    final ttfItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoItalic));
    final ttfBoldItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBoldItalic));
    final ttfNotoSansSymbols = pw.Font.ttf(await rootBundle.load(AppAssets.notoSansSymbols));

    pw.TextStyle size22Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: isLandscape ? 14 : 22,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.TextStyle size16Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: isLandscape ? 10 : 16,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
    );

    pw.TextStyle size12Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: isLandscape ? 9.5 : 12,
      fontWeight: pw.FontWeight.bold,
      fontFallback: [
        ttfNotoSansSymbols,
      ],
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
            fontFallback: [
              ttfNotoSansSymbols,
            ],
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
                      width: isLandscape ? 16 : 30,
                      child: TableHeadingCell(title: AppStrings.sr.tr),
                    ),

                    /// Category
                    pw.SizedBox(
                      width: isLandscape ? 28 : 48,
                      child: TableHeadingCell(title: AppStrings.cat.tr),
                    ),

                    /// In Date
                    pw.SizedBox(
                      width: isLandscape ? 47 : 75,
                      child: TableHeadingCell(title: AppStrings.inDate.tr),
                    ),

                    /// PVD Color
                    pw.SizedBox(
                      width: isLandscape ? 38 : 60,
                      child: TableHeadingCell(title: AppStrings.pvdColor.tr),
                    ),

                    /// Item
                    TableHeadingCell(title: AppStrings.item.tr),

                    /// Inch
                    pw.SizedBox(
                      width: isLandscape ? 18 : 37,
                      child: TableHeadingCell(title: AppStrings.inch.tr),
                    ),

                    /// QTY
                    pw.SizedBox(
                      width: isLandscape ? 22 : 38,
                      child: TableHeadingCell(title: AppStrings.qty.tr),
                    ),

                    /// Previous
                    pw.SizedBox(
                      width: isLandscape ? 22 : 38,
                      child: TableHeadingCell(title: AppStrings.previous.tr),
                    ),

                    /// OK
                    pw.SizedBox(
                      width: isLandscape ? 22 : 38,
                      child: TableHeadingCell(title: AppStrings.ok.tr),
                    ),

                    /// W/O
                    pw.SizedBox(
                      width: isLandscape ? 18 : 37,
                      child: TableHeadingCell(title: AppStrings.wo.tr),
                    ),

                    /// Total Inch
                    pw.SizedBox(
                      width: isLandscape ? 28 : 48,
                      child: TableHeadingCell(title: AppStrings.totalInch.tr.replaceAll("C1 ", "")),
                    ),

                    /// Balance QTY
                    pw.SizedBox(
                      width: isLandscape ? 22 : 38,
                      child: TableHeadingCell(title: AppStrings.balanceQTY.tr),
                    ),

                    if (showAmount) ...[
                      ///Price
                      pw.SizedBox(
                        width: isLandscape ? 16 : 30,
                        child: TableHeadingCell(title: AppStrings.pr.tr),
                      ),

                      /// Total Amount
                      TableHeadingCell(title: AppStrings.totalAmount.tr.replaceAll("C1 ", "")),
                    ],
                  ],
                ),

                for (int i = 0; i < data.length; i++) ...[
                  pw.TableRow(
                    children: [
                      /// SR.
                      pw.SizedBox(
                        width: isLandscape ? 16 : 30,
                        child: TableCell(title: NumberFormat("00").format(i + 1)),
                      ),

                      /// Category
                      pw.SizedBox(
                        width: isLandscape ? 28 : 48,
                        child: TableCell(title: data[i].categoryName ?? ""),
                      ),

                      /// In Date
                      pw.SizedBox(
                        width: isLandscape ? 47 : 75,
                        child: TableCell(title: DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(data[i].inDate ?? ""))),
                      ),

                      /// PVD Color
                      pw.SizedBox(
                        width: isLandscape ? 38 : 60,
                        child: TableCell(title: data[i].pvdColor ?? ""),
                      ),

                      /// Item
                      TableCell(title: data[i].itemName ?? ""),

                      /// Inch
                      pw.SizedBox(
                        width: isLandscape ? 18 : 37,
                        child: TableCell(title: data[i].inch ?? ""),
                      ),

                      /// QTY
                      pw.SizedBox(
                        width: isLandscape ? 22 : 38,
                        child: TableCell(title: data[i].quantity ?? ""),
                      ),

                      /// Previous
                      pw.SizedBox(
                        width: isLandscape ? 22 : 38,
                        child: TableCell(title: data[i].previous ?? ""),
                      ),

                      /// OK
                      pw.SizedBox(
                        width: isLandscape ? 22 : 38,
                        child: TableCell(title: data[i].okPcs ?? ""),
                      ),

                      /// W/O
                      pw.SizedBox(
                        width: isLandscape ? 18 : 37,
                        child: TableCell(title: data[i].woProcess ?? ""),
                      ),

                      /// Total Inch
                      pw.SizedBox(
                        width: isLandscape ? 28 : 48,
                        child: TableCell(title: data[i].totalInch ?? ""),
                      ),

                      /// Balance QTY
                      pw.SizedBox(
                        width: isLandscape ? 22 : 38,
                        child: TableCell(title: data[i].balanceQuantity ?? ""),
                      ),

                      if (showAmount) ...[
                        /// Price
                        pw.SizedBox(
                          width: isLandscape ? 18 : 37,
                          child: TableCell(title: "₹${data[i].categoryPrice ?? ""}"),
                        ),

                        /// Total Amount
                        TableCell(title: data[i].totalAmount != null && data[i].totalAmount?.isNotEmpty == true ? NumberFormat.currency(locale: "hi_IN", symbol: "₹").format(data[i].totalAmount!.toDouble()) : ""),
                      ],
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

  Future<void> showDeleteDialog({
    required void Function()? onPressed,
    required String title,
    IconData? iconData,
    Color? iconColor,
    String? agreeText,
  }) async {
    await showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: 'string',
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.WHITE_COLOR,
          surfaceTintColor: AppColors.WHITE_COLOR,
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.WHITE_COLOR,
            ),
            width: 80.w,
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                Icon(
                  iconData ?? Icons.delete_forever_rounded,
                  color: iconColor ?? AppColors.DARK_RED_COLOR,
                  size: 8.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Cancel
                      ButtonWidget(
                        onPressed: () {
                          Get.back();
                        },
                        fixedSize: Size(30.w, 5.h),
                        buttonTitle: AppStrings.cancel.tr,
                        buttonColor: AppColors.DARK_GREEN_COLOR,
                        buttonTitleColor: AppColors.PRIMARY_COLOR,
                      ),

                      ///Delete
                      ButtonWidget(
                        onPressed: onPressed,
                        fixedSize: Size(30.w, 5.h),
                        buttonTitle: agreeText ?? AppStrings.delete.tr,
                        buttonColor: AppColors.DARK_RED_COLOR,
                        buttonTitleColor: AppColors.PRIMARY_COLOR,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      },
    );
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

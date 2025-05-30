import 'dart:io';

import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart' as get_invoices;
import 'package:cph_stocks/Network/services/challan_services/challan_service.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

  /// @function downloadPdf
  /// @description download pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future<File?>} - Returns a Future of a File object
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<File?> downloadPdf({required File pdfFile}) async {
    if (pdfFile.existsSync()) {
      final directory = Directory('/storage/emulated/0/Download');
      if (directory.existsSync()) {
        final filePath = '${directory.path}/${pdfFile.path.split('/').last}';
        return await pdfFile.copy(filePath);
      }
    }
    return null;
  }

  /// @function printPdf
  /// @description print pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future<bool>} - Returns a Future of a boolean value
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<bool> printPdf({required File pdfFile}) async {
    if (pdfFile.existsSync()) {
      return await Printing.layoutPdf(
        format: pdf.PdfPageFormat.a3,
        usePrinterSettings: true,
        forceCustomPrintPaper: true,
        onLayout: (_) => pdfFile.readAsBytesSync(),
      );
    }
    return false;
  }

  /// @function sharePdf
  /// @description share pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future<bool>} - Returns a Future of a boolean value
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<bool> sharePdf({required File pdfFile}) async {
    if (pdfFile.existsSync()) {
      return await Printing.sharePdf(
        bytes: pdfFile.readAsBytesSync(),
        filename: pdfFile.path.split('/').last,
      );
    }
    return false;
  }

  /// @function generatePdf
  /// @description generate pdf from data
  /// @param {List<get_invoices.InvoiceMeta>} data - List of invoice data
  /// @param {String} partyName - Party name
  /// @param {String} challanNumber - Challan number
  /// @param {String} createdDate - Created date
  /// @returns {Future<File?>} - Returns a Future of a File object
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<File?> generatePdf({
    required String partyName,
    required String challanNumber,
    required String createdDate,
    required List<get_invoices.InvoiceMeta> data,
  }) async {
    final pdfDoc = pw.Document();

    pw.TextStyle size20Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 22,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle size16Font = pw.TextStyle(
      color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );

    pw.Widget TableCell({
      required String title,
    }) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: pw.Text(
          title,
          style: size16Font,
        ),
      );
    }

    pdfDoc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pdf.PdfPageFormat.a3,
          margin: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
            italic: pw.Font.helveticaOblique(),
            boldItalic: pw.Font.helveticaBoldOblique(),
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
                  constraints: pw.BoxConstraints(maxWidth: 350),
                  child: pw.Text(
                    partyName,
                    style: size20Font,
                  ),
                ),

                /// Challan Number
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 10),
                  child: pw.Text(
                    challanNumber,
                    style: size20Font,
                  ),
                ),

                /// Created Date
                pw.Text(
                  "${AppStrings.date.tr}: ${DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(createdDate))}",
                  style: size20Font,
                ),
              ],
            ),
            pw.SizedBox(height: 10),

            /// Invoice Table
            pw.Table(
              border: pw.TableBorder.all(
                color: pdf.PdfColor.fromInt(AppColors.SECONDARY_COLOR.toARGB32()),
                width: 0.5.w,
              ),
              children: [
                /// Header
                pw.TableRow(
                  children: [
                    /// SR.
                    pw.SizedBox(
                      width: 38,
                      child: TableCell(title: AppStrings.sr.tr),
                    ),

                    /// Category
                    TableCell(title: AppStrings.category.tr),

                    /// PVD Color
                    TableCell(title: AppStrings.pvdColor.tr),

                    /// Item
                    TableCell(title: AppStrings.item.tr),

                    /// In Date
                    pw.SizedBox(
                      width: 79,
                      child: TableCell(title: AppStrings.inDate.tr),
                    ),

                    /// QTY
                    TableCell(title: AppStrings.qty.tr),

                    /// Previous
                    TableCell(title: AppStrings.previous.tr),

                    /// OK
                    TableCell(title: AppStrings.ok.tr),

                    /// W/O
                    TableCell(title: AppStrings.wo.tr),

                    /// Inch
                    TableCell(title: AppStrings.inch.tr),

                    /// Total Inch
                    TableCell(title: AppStrings.totalInch.tr),

                    /// Balance QTY
                    TableCell(title: AppStrings.balanceQTY.tr),
                  ],
                ),

                for (int i = 0; i < data.length; i++) ...[
                  pw.TableRow(
                    children: [
                      /// SR.
                      TableCell(title: NumberFormat("00").format(i + 1)),

                      /// Category
                      TableCell(title: data[i].categoryName ?? ""),

                      /// PVD Color
                      TableCell(title: data[i].pvdColor ?? ""),

                      /// Item
                      TableCell(title: data[i].itemName ?? ""),

                      /// In Date
                      TableCell(title: DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(data[i].inDate ?? ""))),

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
                    ],
                  ),
                ],
              ],
            ),
          ];
        },
      ),
    );

    final status = await permissionStatus();
    if (status.$1.isGranted || status.$2.isGranted) {
      final dir = await getApplicationCacheDirectory();
      final fileName = '${partyName}_${challanNumber}_$createdDate'.cleanFileName;
      final file = File('${dir.path}/$fileName.pdf');
      final fileBytes = await pdfDoc.save();
      return await file.writeAsBytes(fileBytes);
    }
    return null;
  }

  Future<(PermissionStatus storageStatus, PermissionStatus photosStatus)> permissionStatus() async {
    // Default values
    PermissionStatus storageStatus = PermissionStatus.granted;
    PermissionStatus photosStatus = PermissionStatus.granted;

    Future<void> recheckStatus() async {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVersion = androidInfo.version.sdkInt;
        if (androidVersion >= 33) {
          // Android 13+ (Scoped Storage) – storage not needed, only media access
          photosStatus = await Permission.photos.status;
        } else {
          // Android ≤ 12 – needs storage and possibly photos
          storageStatus = await Permission.storage.status;
        }
      } else {
        // iOS – only photos access needed
        photosStatus = await Permission.photos.status;
      }
    }

    await recheckStatus();

    // If any permission is permanently denied
    if (storageStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
      if (kDebugMode) {
        print("Permission ::::: PermanentlyDenied");
      }
      await openAppSettings();
    }

    // Re-check
    await recheckStatus();

    // Request if denied
    if (storageStatus.isDenied || photosStatus.isDenied) {
      if (kDebugMode) {
        print("Permission ::::: Denied");
      }

      final requests = <Permission>[];

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVersion = androidInfo.version.sdkInt;
        if (androidVersion < 33 && storageStatus.isDenied) {
          requests.add(Permission.storage);
        }
        if (photosStatus.isDenied) {
          requests.add(Permission.photos);
        }
      } else {
        if (photosStatus.isDenied) {
          requests.add(Permission.photos);
        }
      }

      if (requests.isNotEmpty) {
        await requests.request();
      }
    }

    // Final check before return
    await recheckStatus();

    return (storageStatus, photosStatus);
  }
}

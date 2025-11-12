import 'dart:developer';
import 'dart:io';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/cash_flow_models/get_cash_flow_model.dart' as get_cash_flow;
import 'package:cph_stocks/Network/response_model.dart';
import 'package:cph_stocks/Network/services/cash_flow_services/cash_flow_services.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class CashFlowController extends GetxController with GetTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  TextEditingController searchCashFlowController = TextEditingController();

  RxList<get_cash_flow.CashFlowData> allCashFlowList = RxList();
  RxList<get_cash_flow.CashFlowData> cashCashFlowList = RxList();
  RxList<get_cash_flow.CashFlowData> onlineCashFlowList = RxList();
  RxList<get_cash_flow.CashFlowData> searchCashCashFlowList = RxList();
  RxList<get_cash_flow.CashFlowData> searchOnlineCashFlowList = RxList();

  Rx<get_cash_flow.Summary> summeryData = Rx(get_cash_flow.Summary());
  Rx<get_cash_flow.Summary> cashSummeryData = Rx(get_cash_flow.Summary());
  Rx<get_cash_flow.Summary> onlineSummeryData = Rx(get_cash_flow.Summary());

  Rx<DateTimeRange<DateTime>?> filterDateRange = Rx(DateTimeRange<DateTime>(start: DateTime.now().subtract(7.days), end: DateTime.now()));

  RxString deletingId = "".obs;
  RxString acceptDeletingId = "".obs;
  RxString rejectDeletingId = "".obs;

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  List<String> tabTypes = [
    AppStrings.cash,
    AppStrings.online,
  ];

  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  RxBool switchFilteredSummary = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex(tabController.index);
    });
    getCashFlowApiCall();
  }

  Rx<get_cash_flow.Summary> get getSummeryData => switchFilteredSummary.isTrue
      ? tabIndex.value == 0
            ? cashSummeryData
            : onlineSummeryData
      : summeryData;

  Future<void> getCashFlowApiCall({bool isRefresh = false}) async {
    try {
      isLoading(!isRefresh);
      final response = await CashFlowServices.getCashFlowService(
        startDate: filterDateRange.value?.start.toLocal().toString().split(" ").first ?? "",
        endDate: filterDateRange.value?.end.toLocal().toString().split(" ").first ?? "",
      );
      if (response.isSuccess) {
        get_cash_flow.GetCashFlowModel cashFlowModel = get_cash_flow.GetCashFlowModel.fromJson(response.response?.data ?? {});

        summeryData.value = cashFlowModel.summary ?? summeryData.value;
        cashSummeryData.value = cashFlowModel.cashSummary ?? cashSummeryData.value;
        onlineSummeryData.value = cashFlowModel.onlineSummary ?? onlineSummeryData.value;

        allCashFlowList.clear();
        cashCashFlowList.clear();
        onlineCashFlowList.clear();
        searchCashCashFlowList.clear();
        searchOnlineCashFlowList.clear();
        allCashFlowList.addAll(cashFlowModel.data ?? []);
        cashCashFlowList.addAll(allCashFlowList.where((element) => element.modeOfPayment == AppStrings.cash).toList());
        searchCashCashFlowList.addAll([...cashCashFlowList]);
        onlineCashFlowList.addAll(allCashFlowList.where((element) => element.modeOfPayment != AppStrings.cash).toList());
        searchOnlineCashFlowList.addAll([...onlineCashFlowList]);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCashFlowApiCall({required String cashFlowId}) async {
    try {
      deletingId(cashFlowId);
      final response = await CashFlowServices.deleteCashFlowService(
        cashFlowId: cashFlowId,
      );
      if (response.isSuccess) {
        await getCashFlowApiCall();
        Utils.handleMessage(message: response.message);
      }
    } finally {
      deletingId("");
    }
  }

  Future<ResponseModel> addCashFlowApiCall({
    required String cashType,
    required String note,
    required String modeOfPayment,
    required String amount,
    required String createdDate,
  }) async {
    final response = await CashFlowServices.addCashFlowService(
      note: note,
      cashType: cashType,
      amount: amount,
      modeOfPayment: modeOfPayment,
      createdDate: createdDate,
    );
    return response;
  }

  Future<ResponseModel> editCashFlowApiCall({
    required String cashFlowId,
    required String cashType,
    required String note,
    required String modeOfPayment,
    required String amount,
    required String createdDate,
  }) async {
    final response = await CashFlowServices.editCashFlowService(
      cashFlowId: cashFlowId,
      note: note,
      cashType: cashType,
      amount: amount,
      modeOfPayment: modeOfPayment,
      createdDate: createdDate,
    );
    return response;
  }

  Future<void> acceptRejectDeleteCashFlowApiCall({
    required String cashFlowId,
    required bool isAccept,
  }) async {
    try {
      acceptDeletingId(isAccept ? cashFlowId : "");
      rejectDeletingId(!isAccept ? cashFlowId : "");
      final response = await CashFlowServices.acceptRejectDeleteCashFlowService(
        cashFlowId: cashFlowId,
        isAccept: isAccept,
      );
      if (response.isSuccess) {
        await getCashFlowApiCall();
        Utils.handleMessage(message: response.message);
      }
    } finally {
      acceptDeletingId("");
      rejectDeletingId("");
    }
  }

  Future<File?> exportCashFlowData({
    required List<get_cash_flow.CashFlowData> cashFlowList,
    required get_cash_flow.Summary summary,
  }) async {
    try {
      final pdf = pw.Document();

      final dateFormat = DateFormat('dd MMM yyyy');
      final timeFormat = DateFormat('hh:mm a');

      final now = DateTime.now();
      final formattedDate = dateFormat.format(now);
      final formattedTime = timeFormat.format(now);

      final ttfRegular = pw.Font.ttf(await rootBundle.load(AppAssets.robotoRegular));
      final ttfBold = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBold));
      final ttfItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoItalic));
      final ttfBoldItalic = pw.Font.ttf(await rootBundle.load(AppAssets.robotoBoldItalic));
      final ttfNotoSansSymbols = pw.Font.ttf(await rootBundle.load(AppAssets.notoSansSymbols));

      String currencyNumberFormat(double value) {
        return NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(value);
      }

      pdf.addPage(
        pw.MultiPage(
          margin: const pw.EdgeInsets.all(16),
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
          build: (context) => [
            // HEADER
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  AppStrings.cashFlowReport.tr,
                  style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  "${AppStrings.generatedOn.tr} - $formattedDate, $formattedTime",
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  "${AppStrings.generatedBy.tr} - ${getData(AppConstance.userName)}",
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  "${AppStrings.duration.tr}: ${summary.startDate != null ? dateFormat.format(DateTime.parse(summary.startDate!)) : ""} - ${summary.endDate != null ? dateFormat.format(DateTime.parse(summary.endDate!)) : ""}",
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "${AppStrings.totalIn.tr}: ${currencyNumberFormat(summary.totalIn?.toDouble() ?? 0.0)}",
                      style: const pw.TextStyle(fontSize: 13),
                    ),
                    pw.Text(
                      "${AppStrings.totalOut.tr}: ${currencyNumberFormat(summary.totalOut?.toDouble() ?? 0.0)}",
                      style: const pw.TextStyle(fontSize: 13),
                    ),
                    pw.Text(
                      "${AppStrings.finalBalance.tr}: ${currencyNumberFormat(summary.netBalance?.toDouble() ?? 0.0)}",
                      style: const pw.TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Text("${AppStrings.totalEntries.tr}: ${cashFlowList.length}", style: const pw.TextStyle(fontSize: 12)),
                pw.Divider(thickness: 1.2),
              ],
            ),

            pw.SizedBox(height: 8),

            // TABLE HEADER
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey700),
              columnWidths: {
                0: const pw.FixedColumnWidth(70), // Date  ↑
                1: const pw.FlexColumnWidth(2.4), // Remark ↑
                2: const pw.FlexColumnWidth(1.5), // Entry by ↑
                3: const pw.FixedColumnWidth(75), // Mode ↑
                4: const pw.FixedColumnWidth(70), // In ↑
                5: const pw.FixedColumnWidth(70), // Out ↓
                6: const pw.FixedColumnWidth(70), // Balance ↑
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(AppStrings.date.tr, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(AppStrings.remark.tr, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(AppStrings.entryBy.tr, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(AppStrings.mode.tr, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        AppStrings.inWord.tr,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(AppStrings.out.tr, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(AppStrings.balance.tr, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),

                // DATA ROWS
                ...cashFlowList.map((e) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(e.createdDate != null ? dateFormat.format(DateTime.parse(e.createdDate!)) : '', style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(e.note ?? '', style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(e.createdBy ?? '', style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(e.modeOfPayment ?? '', style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          e.cashType == "IN" ? (e.amount != null ? currencyNumberFormat(e.amount?.toDouble() ?? 0.0) : '') : '',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          e.cashType == "OUT" ? (e.amount != null ? currencyNumberFormat(e.amount?.toDouble() ?? 0.0) : '') : '',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          e.balance != null ? currencyNumberFormat(e.balance?.toDouble() ?? 0.0) : '',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  );
                }),

                // Final Balance
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(dateFormat.format(DateTime.now()), style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(AppStrings.finalBalance.tr, style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        currencyNumberFormat(summary.netBalance?.toDouble() ?? 0.0),
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
          ],
        ),
      );

      final status = await Utils.getDashboardController.permissionStatus();
      if (status.$1.isGranted || status.$2.isGranted) {
        final dir = await getApplicationCacheDirectory();
        final file = File("${dir.path}/CashFlow_${DateTime.now().millisecondsSinceEpoch}.pdf");
        final fileBytes = await pdf.save();
        await file.writeAsBytes(fileBytes);
        return file;
      } else {
        return null;
      }
    } catch (e) {
      log("Error creating PDF: $e");
      return null;
    }
  }
}

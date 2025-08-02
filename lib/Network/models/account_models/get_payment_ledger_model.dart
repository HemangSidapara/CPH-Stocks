import 'package:json_annotation/json_annotation.dart';

part 'get_payment_ledger_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetPaymentLedgerModel {
  String? code;
  String? msg;
  String? startDate;
  String? endDate;
  String? partyId;
  String? partyName;
  bool? isGst;
  LedgerSummary? summary;
  List<LedgerPayment>? payments;
  List<LedgerInvoice>? invoices;

  GetPaymentLedgerModel({
    this.code,
    this.msg,
    this.startDate,
    this.endDate,
    this.partyId,
    this.partyName,
    this.isGst,
    this.summary,
    this.payments,
    this.invoices,
  });

  factory GetPaymentLedgerModel.fromJson(Map<String, dynamic> json) => _$GetPaymentLedgerModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetPaymentLedgerModelToJson(this);

  GetPaymentLedgerModel copyWith({
    String? code,
    String? msg,
    String? startDate,
    String? endDate,
    String? partyId,
    String? partyName,
    bool? isGst,
    LedgerSummary? summary,
    List<LedgerPayment>? payments,
    List<LedgerInvoice>? invoices,
  }) {
    return GetPaymentLedgerModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      isGst: isGst ?? this.isGst,
      summary: summary ?? this.summary,
      payments: payments ?? this.payments,
      invoices: invoices ?? this.invoices,
    );
  }
}

@JsonSerializable()
class LedgerSummary {
  double? openingAmount;
  double? totalInvoiceAmount;
  double? totalPaymentAmount;
  double? pendingAmount;

  LedgerSummary({
    this.openingAmount,
    this.totalInvoiceAmount,
    this.totalPaymentAmount,
    this.pendingAmount,
  });

  factory LedgerSummary.fromJson(Map<String, dynamic> json) => _$LedgerSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerSummaryToJson(this);

  LedgerSummary copyWith({
    double? openingAmount,
    double? totalInvoiceAmount,
    double? totalPaymentAmount,
    double? pendingAmount,
  }) {
    return LedgerSummary(
      openingAmount: openingAmount ?? this.openingAmount,
      totalInvoiceAmount: totalInvoiceAmount ?? this.totalInvoiceAmount,
      totalPaymentAmount: totalPaymentAmount ?? this.totalPaymentAmount,
      pendingAmount: pendingAmount ?? this.pendingAmount,
    );
  }
}

@JsonSerializable()
class LedgerPayment {
  double? amount;
  String? paymentMode;
  String? createdDate;

  LedgerPayment({
    this.amount,
    this.paymentMode,
    this.createdDate,
  });

  factory LedgerPayment.fromJson(Map<String, dynamic> json) => _$LedgerPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerPaymentToJson(this);

  LedgerPayment copyWith({
    double? amount,
    String? paymentMode,
    String? createdDate,
  }) {
    return LedgerPayment(
      amount: amount ?? this.amount,
      paymentMode: paymentMode ?? this.paymentMode,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}

@JsonSerializable()
class LedgerInvoice {
  String? orderInvoiceId;
  String? challanNumber;
  String? createdDate;
  double? totalAmount;

  LedgerInvoice({
    this.orderInvoiceId,
    this.challanNumber,
    this.createdDate,
    this.totalAmount,
  });

  factory LedgerInvoice.fromJson(Map<String, dynamic> json) => _$LedgerInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerInvoiceToJson(this);

  LedgerInvoice copyWith({
    String? orderInvoiceId,
    String? challanNumber,
    String? createdDate,
    double? totalAmount,
  }) {
    return LedgerInvoice(
      orderInvoiceId: orderInvoiceId ?? this.orderInvoiceId,
      challanNumber: challanNumber ?? this.challanNumber,
      createdDate: createdDate ?? this.createdDate,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

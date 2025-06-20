import 'package:json_annotation/json_annotation.dart';

part 'get_automatic_ledger_payment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetAutomaticLedgerPaymentModel {
  String? code;
  String? msg;
  String? startDate;
  String? endDate;
  List<LedgerPartyData>? data;

  GetAutomaticLedgerPaymentModel({
    this.code,
    this.msg,
    this.startDate,
    this.endDate,
    this.data,
  });

  factory GetAutomaticLedgerPaymentModel.fromJson(Map<String, dynamic> json) => _$GetAutomaticLedgerPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetAutomaticLedgerPaymentModelToJson(this);

  GetAutomaticLedgerPaymentModel copyWith({
    String? code,
    String? msg,
    String? startDate,
    String? endDate,
    List<LedgerPartyData>? data,
  }) {
    return GetAutomaticLedgerPaymentModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LedgerPartyData {
  String? partyId;
  String? partyName;
  LedgerSummary? summary;
  List<LedgerPayment>? payments;
  List<LedgerInvoice>? invoices;

  LedgerPartyData({
    this.partyId,
    this.partyName,
    this.summary,
    this.payments,
    this.invoices,
  });

  factory LedgerPartyData.fromJson(Map<String, dynamic> json) => _$LedgerPartyDataFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerPartyDataToJson(this);

  LedgerPartyData copyWith({
    String? partyId,
    String? partyName,
    LedgerSummary? summary,
    List<LedgerPayment>? payments,
    List<LedgerInvoice>? invoices,
  }) {
    return LedgerPartyData(
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      summary: summary ?? this.summary,
      payments: payments ?? this.payments,
      invoices: invoices ?? this.invoices,
    );
  }
}

@JsonSerializable()
class LedgerSummary {
  double? totalInvoiceAmount;
  double? totalPaymentAmount;
  double? pendingAmount;

  LedgerSummary({
    this.totalInvoiceAmount,
    this.totalPaymentAmount,
    this.pendingAmount,
  });

  factory LedgerSummary.fromJson(Map<String, dynamic> json) => _$LedgerSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerSummaryToJson(this);

  LedgerSummary copyWith({
    double? totalInvoiceAmount,
    double? totalPaymentAmount,
    double? pendingAmount,
  }) {
    return LedgerSummary(
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

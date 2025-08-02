import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_automatic_ledger_invoice_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetAutomaticLedgerInvoiceModel {
  String? code;
  String? msg;
  String? startDate;
  String? endDate;
  List<GetPartyData>? data;

  GetAutomaticLedgerInvoiceModel({
    this.code,
    this.msg,
    this.startDate,
    this.endDate,
    this.data,
  });

  factory GetAutomaticLedgerInvoiceModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> newData = json['data'] is List ? json['data'].cast<Map<String, dynamic>>() : [];
    if (newData.isNotEmpty) {
      json['data'] = newData.map((e) {
        e['startDate'] = json['startDate'];
        e['endDate'] = json['endDate'];
        return e;
      }).toList();
    }
    return _$GetAutomaticLedgerInvoiceModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetAutomaticLedgerInvoiceModelToJson(this);

  GetAutomaticLedgerInvoiceModel copyWith({
    String? code,
    String? msg,
    String? startDate,
    String? endDate,
    List<GetPartyData>? data,
  }) {
    return GetAutomaticLedgerInvoiceModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GetPartyData {
  String? partyId;
  String? partyName;
  bool? isGst;
  String? startDate;
  String? endDate;
  List<OrderInvoice>? invoices;

  GetPartyData({
    this.partyId,
    this.partyName,
    this.isGst,
    this.startDate,
    this.endDate,
    this.invoices,
  });

  factory GetPartyData.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> newData = json['data'] is List ? json['data'].cast<Map<String, dynamic>>() : [];
    if (newData.isNotEmpty) {
      json['data'] = newData.map((e) {
        e['startDate'] = json['startDate'];
        e['endDate'] = json['endDate'];
        return e;
      }).toList();
    }
    return _$GetPartyDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetPartyDataToJson(this);

  GetPartyData copyWith({
    String? partyId,
    String? partyName,
    bool? isGst,
    String? startDate,
    String? endDate,
    List<OrderInvoice>? invoices,
  }) {
    return GetPartyData(
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      isGst: isGst ?? this.isGst,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      invoices: invoices ?? this.invoices,
    );
  }
}

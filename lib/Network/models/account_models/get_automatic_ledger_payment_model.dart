import 'package:cph_stocks/Network/models/account_models/get_payment_ledger_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_automatic_ledger_payment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetAutomaticLedgerPaymentModel {
  String? code;
  String? msg;
  String? startDate;
  String? endDate;
  List<GetPaymentLedgerModel>? data;

  GetAutomaticLedgerPaymentModel({
    this.code,
    this.msg,
    this.startDate,
    this.endDate,
    this.data,
  });

  factory GetAutomaticLedgerPaymentModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> newData = json['data'] is List ? json['data'].cast<Map<String, dynamic>>() : [];
    if (newData.isNotEmpty) {
      json['data'] = newData.map((e) {
        e['startDate'] = json['startDate'];
        e['endDate'] = json['endDate'];
        return e;
      }).toList();
    }
    return _$GetAutomaticLedgerPaymentModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetAutomaticLedgerPaymentModelToJson(this);

  GetAutomaticLedgerPaymentModel copyWith({
    String? code,
    String? msg,
    String? startDate,
    String? endDate,
    List<GetPaymentLedgerModel>? data,
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

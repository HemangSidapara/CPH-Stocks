import 'package:json_annotation/json_annotation.dart';

part 'get_party_payment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetPartyPaymentModel {
  String? code;
  String? msg;
  List<PartyPaymentData>? data;

  GetPartyPaymentModel({
    this.code,
    this.msg,
    this.data,
  });

  factory GetPartyPaymentModel.fromJson(Map<String, dynamic> json) => _$GetPartyPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetPartyPaymentModelToJson(this);

  GetPartyPaymentModel copyWith({
    String? code,
    String? msg,
    List<PartyPaymentData>? data,
  }) {
    return GetPartyPaymentModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class PartyPaymentData {
  String? partyPaymentMetaId;
  String? amount;
  String? paymentMode;
  String? createdDate;
  String? createdTime;

  PartyPaymentData({
    this.partyPaymentMetaId,
    this.amount,
    this.paymentMode,
    this.createdDate,
    this.createdTime,
  });

  factory PartyPaymentData.fromJson(Map<String, dynamic> json) => _$PartyPaymentDataFromJson(json);

  Map<String, dynamic> toJson() => _$PartyPaymentDataToJson(this);

  PartyPaymentData copyWith({
    String? partyPaymentMetaId,
    String? amount,
    String? paymentMode,
    String? createdDate,
    String? createdTime,
  }) {
    return PartyPaymentData(
      partyPaymentMetaId: partyPaymentMetaId ?? this.partyPaymentMetaId,
      amount: amount ?? this.amount,
      paymentMode: paymentMode ?? this.paymentMode,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}

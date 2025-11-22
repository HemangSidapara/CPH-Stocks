import 'package:json_annotation/json_annotation.dart';

part 'get_all_payments_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetAllPaymentsModel {
  String? code;
  String? msg;
  List<PartyPaymentData>? data;

  GetAllPaymentsModel({
    this.code,
    this.msg,
    this.data,
  });

  factory GetAllPaymentsModel.fromJson(Map<String, dynamic> json) => _$GetAllPaymentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllPaymentsModelToJson(this);

  GetAllPaymentsModel copyWith({
    String? code,
    String? msg,
    List<PartyPaymentData>? data,
  }) {
    return GetAllPaymentsModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class PartyPaymentData {
  String? partyPaymentMetaId;
  String? partyPaymentId;
  String? partyId;
  String? partyName;
  String? amount;
  String? discount;
  String? paymentImage;
  String? paymentMode;
  String? createdDate;
  String? createdTime;

  PartyPaymentData({
    this.partyPaymentMetaId,
    this.partyPaymentId,
    this.partyId,
    this.partyName,
    this.amount,
    this.discount,
    this.paymentImage,
    this.paymentMode,
    this.createdDate,
    this.createdTime,
  });

  factory PartyPaymentData.fromJson(Map<String, dynamic> json) => _$PartyPaymentDataFromJson(json);

  Map<String, dynamic> toJson() => _$PartyPaymentDataToJson(this);

  PartyPaymentData copyWith({
    String? partyPaymentMetaId,
    String? partyPaymentId,
    String? partyId,
    String? partyName,
    String? amount,
    String? discount,
    String? paymentImage,
    String? paymentMode,
    String? createdDate,
    String? createdTime,
  }) {
    return PartyPaymentData(
      partyPaymentMetaId: partyPaymentMetaId ?? this.partyPaymentMetaId,
      partyPaymentId: partyPaymentId ?? this.partyPaymentId,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      amount: amount ?? this.amount,
      discount: discount ?? this.discount,
      paymentImage: paymentImage ?? this.paymentImage,
      paymentMode: paymentMode ?? this.paymentMode,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}

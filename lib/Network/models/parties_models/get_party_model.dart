import 'package:json_annotation/json_annotation.dart';

part 'get_party_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetPartyModel {
  String? code;
  String? msg;
  int? count;
  List<PartyData>? data;

  GetPartyModel({this.code, this.msg, this.count, this.data});

  factory GetPartyModel.fromJson(Map<String, dynamic> json) => _$GetPartyModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetPartyModelToJson(this);

  GetPartyModel copyWith({String? code, String? msg, int? count, List<PartyData>? data}) {
    return GetPartyModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      count: count ?? this.count,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class PartyData {
  String? orderId;
  String? partyName;
  String? contactNumber;
  num? pendingBalance;
  bool? isGst;
  String? paymentType;
  String? createdDate;
  String? createdTime;

  PartyData({
    this.orderId,
    this.partyName,
    this.contactNumber,
    this.pendingBalance,
    this.isGst,
    this.paymentType,
    this.createdDate,
    this.createdTime,
  });

  factory PartyData.fromJson(Map<String, dynamic> json) => _$PartyDataFromJson(json);

  Map<String, dynamic> toJson() => _$PartyDataToJson(this);

  PartyData copyWith({
    String? orderId,
    String? partyName,
    String? contactNumber,
    num? pendingBalance,
    bool? isGst,
    String? paymentType,
    String? createdDate,
    String? createdTime,
  }) {
    return PartyData(
      orderId: orderId ?? this.orderId,
      partyName: partyName ?? this.partyName,
      contactNumber: contactNumber ?? this.contactNumber,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      isGst: isGst ?? this.isGst,
      paymentType: paymentType ?? this.paymentType,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}

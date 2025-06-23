import 'package:json_annotation/json_annotation.dart';

part 'get_pending_payments_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetPendingPaymentsModel {
  String? code;
  String? msg;
  double? totalPendingAmount;
  List<PendingParty>? data;

  GetPendingPaymentsModel({
    this.code,
    this.msg,
    this.totalPendingAmount,
    this.data,
  });

  factory GetPendingPaymentsModel.fromJson(Map<String, dynamic> json) => _$GetPendingPaymentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetPendingPaymentsModelToJson(this);

  GetPendingPaymentsModel copyWith({
    String? code,
    String? msg,
    double? totalPendingAmount,
    List<PendingParty>? data,
  }) {
    return GetPendingPaymentsModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      totalPendingAmount: totalPendingAmount ?? this.totalPendingAmount,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class PendingParty {
  String? partyId;
  String? partyName;
  double? pendingAmount;

  PendingParty({
    this.partyId,
    this.partyName,
    this.pendingAmount,
  });

  factory PendingParty.fromJson(Map<String, dynamic> json) => _$PendingPartyFromJson(json);

  Map<String, dynamic> toJson() => _$PendingPartyToJson(this);

  PendingParty copyWith({
    String? partyId,
    String? partyName,
    double? pendingAmount,
  }) {
    return PendingParty(
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      pendingAmount: pendingAmount ?? this.pendingAmount,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'get_cash_flow_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetCashFlowModel {
  String? code;
  String? msg;
  Summary? summary;
  List<CashFlowData>? data;

  GetCashFlowModel({
    this.code,
    this.msg,
    this.summary,
    this.data,
  });

  factory GetCashFlowModel.fromJson(Map<String, dynamic> json) => _$GetCashFlowModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetCashFlowModelToJson(this);

  GetCashFlowModel copyWith({
    String? code,
    String? msg,
    Summary? summary,
    List<CashFlowData>? data,
  }) {
    return GetCashFlowModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      summary: summary ?? this.summary,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class Summary {
  num? totalIn;
  num? totalOut;
  num? netBalance;

  Summary({
    this.totalIn,
    this.totalOut,
    this.netBalance,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);

  Summary copyWith({
    num? totalIn,
    num? totalOut,
    num? netBalance,
  }) {
    return Summary(
      totalIn: totalIn ?? this.totalIn,
      totalOut: totalOut ?? this.totalOut,
      netBalance: netBalance ?? this.netBalance,
    );
  }
}

@JsonSerializable()
class CashFlowData {
  String? cashFlowId;
  String? cashType;
  String? note;
  String? modeOfPayment;
  String? amount;
  String? createdDate;
  String? createdTime;
  String? createdBy;

  CashFlowData({
    this.cashFlowId,
    this.cashType,
    this.note,
    this.modeOfPayment,
    this.amount,
    this.createdDate,
    this.createdTime,
    this.createdBy,
  });

  factory CashFlowData.fromJson(Map<String, dynamic> json) => _$CashFlowDataFromJson(json);

  Map<String, dynamic> toJson() => _$CashFlowDataToJson(this);

  CashFlowData copyWith({
    String? cashFlowId,
    String? cashType,
    String? note,
    String? modeOfPayment,
    String? amount,
    String? createdDate,
    String? createdTime,
    String? createdBy,
  }) {
    return CashFlowData(
      cashFlowId: cashFlowId ?? this.cashFlowId,
      cashType: cashType ?? this.cashType,
      note: note ?? this.note,
      modeOfPayment: modeOfPayment ?? this.modeOfPayment,
      amount: amount ?? this.amount,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

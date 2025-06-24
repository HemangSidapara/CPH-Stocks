import 'package:json_annotation/json_annotation.dart';

part 'get_reports_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetReportsModel {
  String? code;
  String? msg;
  double? totalInch;
  double? totalCompletedInch;
  double? totalAmount;
  double? totalCompletedAmount;
  List<InchWiseReport>? inchWiseReport;
  List<AmountWiseReport>? amountWiseReport;
  List<NoOfEmployeeReport>? noOfEmployeeReport;

  GetReportsModel({
    this.code,
    this.msg,
    this.totalInch,
    this.totalCompletedInch,
    this.totalAmount,
    this.totalCompletedAmount,
    this.inchWiseReport,
    this.amountWiseReport,
    this.noOfEmployeeReport,
  });

  factory GetReportsModel.fromJson(Map<String, dynamic> json) => _$GetReportsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetReportsModelToJson(this);

  GetReportsModel copyWith({
    String? code,
    String? msg,
    double? totalInch,
    double? totalCompletedInch,
    double? totalAmount,
    double? totalCompletedAmount,
    List<InchWiseReport>? inchWiseReport,
    List<AmountWiseReport>? amountWiseReport,
    List<NoOfEmployeeReport>? noOfEmployeeReport,
  }) {
    return GetReportsModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      totalInch: totalInch ?? this.totalInch,
      totalCompletedInch: totalCompletedInch ?? this.totalCompletedInch,
      totalAmount: totalAmount ?? this.totalAmount,
      totalCompletedAmount: totalCompletedAmount ?? this.totalCompletedAmount,
      inchWiseReport: inchWiseReport ?? this.inchWiseReport,
      amountWiseReport: amountWiseReport ?? this.amountWiseReport,
      noOfEmployeeReport: noOfEmployeeReport ?? this.noOfEmployeeReport,
    );
  }
}

@JsonSerializable()
class InchWiseReport {
  String? date;
  double? totalInch;
  double? completedInch;

  InchWiseReport({
    this.date,
    this.totalInch,
    this.completedInch,
  });

  factory InchWiseReport.fromJson(Map<String, dynamic> json) => _$InchWiseReportFromJson(json);

  Map<String, dynamic> toJson() => _$InchWiseReportToJson(this);

  InchWiseReport copyWith({
    String? date,
    double? totalInch,
    double? completedInch,
  }) {
    return InchWiseReport(
      date: date ?? this.date,
      totalInch: totalInch ?? this.totalInch,
      completedInch: completedInch ?? this.completedInch,
    );
  }
}

@JsonSerializable()
class AmountWiseReport {
  String? date;
  double? totalAmount;
  double? completedAmount;

  AmountWiseReport({
    this.date,
    this.totalAmount,
    this.completedAmount,
  });

  factory AmountWiseReport.fromJson(Map<String, dynamic> json) => _$AmountWiseReportFromJson(json);

  Map<String, dynamic> toJson() => _$AmountWiseReportToJson(this);

  AmountWiseReport copyWith({
    String? date,
    double? totalAmount,
    double? completedAmount,
  }) {
    return AmountWiseReport(
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      completedAmount: completedAmount ?? this.completedAmount,
    );
  }
}

@JsonSerializable()
class NoOfEmployeeReport {
  String? month;
  String? year;
  int? noOfEmployees;

  NoOfEmployeeReport({
    this.month,
    this.year,
    this.noOfEmployees,
  });

  factory NoOfEmployeeReport.fromJson(Map<String, dynamic> json) => _$NoOfEmployeeReportFromJson(json);

  Map<String, dynamic> toJson() => _$NoOfEmployeeReportToJson(this);

  NoOfEmployeeReport copyWith({
    String? month,
    String? year,
    int? noOfEmployees,
  }) {
    return NoOfEmployeeReport(
      month: month ?? this.month,
      year: year ?? this.year,
      noOfEmployees: noOfEmployees ?? this.noOfEmployees,
    );
  }
}

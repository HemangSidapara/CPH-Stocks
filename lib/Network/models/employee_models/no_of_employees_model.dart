import 'package:json_annotation/json_annotation.dart';

part 'no_of_employees_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NoOfEmployeesModel {
  String? code;
  String? msg;
  List<EmployeeRecord>? data;

  NoOfEmployeesModel({
    this.code,
    this.msg,
    this.data,
  });

  factory NoOfEmployeesModel.fromJson(Map<String, dynamic> json) => _$NoOfEmployeesModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoOfEmployeesModelToJson(this);

  NoOfEmployeesModel copyWith({
    String? code,
    String? msg,
    List<EmployeeRecord>? data,
  }) {
    return NoOfEmployeesModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class EmployeeRecord {
  String? totalEmployeeId;
  String? month;
  String? year;
  String? noOfEmployees;

  EmployeeRecord({
    this.totalEmployeeId,
    this.month,
    this.year,
    this.noOfEmployees,
  });

  factory EmployeeRecord.fromJson(Map<String, dynamic> json) => _$EmployeeRecordFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeRecordToJson(this);

  EmployeeRecord copyWith({
    String? totalEmployeeId,
    String? month,
    String? year,
    String? noOfEmployees,
  }) {
    return EmployeeRecord(
      totalEmployeeId: totalEmployeeId ?? this.totalEmployeeId,
      month: month ?? this.month,
      year: year ?? this.year,
      noOfEmployees: noOfEmployees ?? this.noOfEmployees,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'backup_model.g.dart';

@JsonSerializable()
class BackupModel {
  int? code;
  String? msg;
  String? downloadUrl;

  BackupModel({
    this.code,
    this.msg,
    this.downloadUrl,
  });

  factory BackupModel.fromJson(Map<String, dynamic> json) => _$BackupModelFromJson(json);

  Map<String, dynamic> toJson() => _$BackupModelToJson(this);

  BackupModel copyWith({
    int? code,
    String? msg,
    String? downloadUrl,
  }) {
    return BackupModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}

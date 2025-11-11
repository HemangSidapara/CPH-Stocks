import 'package:json_annotation/json_annotation.dart';

part 'get_user_details_model.g.dart';

@JsonSerializable()
class GetUserDetailsModel {
  String? code;
  String? role;
  String? name;
  String? userId;

  GetUserDetailsModel({
    this.code,
    this.role,
    this.name,
    this.userId,
  });

  factory GetUserDetailsModel.fromJson(Map<String, dynamic> json) => _$GetUserDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserDetailsModelToJson(this);

  GetUserDetailsModel copyWith({
    String? code,
    String? role,
    String? name,
    String? userId,
  }) {
    return GetUserDetailsModel(
      code: code ?? this.code,
      role: role ?? this.role,
      name: name ?? this.name,
      userId: userId ?? this.userId,
    );
  }
}

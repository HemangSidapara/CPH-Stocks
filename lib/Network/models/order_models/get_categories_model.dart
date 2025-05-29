import 'package:json_annotation/json_annotation.dart';

part 'get_categories_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetCategoriesModel {
  String? code;
  String? msg;
  @JsonKey(name: 'Data')
  List<CategoryData>? data;

  GetCategoriesModel({
    this.code,
    this.msg,
    this.data,
  });

  // Getters
  String? get getCode => code;
  String? get getMsg => msg;
  List<CategoryData>? get getData => data;

  // copyWith
  GetCategoriesModel copyWith({
    String? code,
    String? msg,
    List<CategoryData>? data,
  }) {
    return GetCategoriesModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      data: data ?? this.data,
    );
  }

  factory GetCategoriesModel.fromJson(Map<String, dynamic> json) => _$GetCategoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetCategoriesModelToJson(this);
}

@JsonSerializable()
class CategoryData {
  String? categoryId;
  String? categoryName;
  String? createdDate;
  String? createdTime;

  CategoryData({
    this.categoryId,
    this.categoryName,
    this.createdDate,
    this.createdTime,
  });

  // Getters
  String? get getCategoryId => categoryId;
  String? get getCategoryName => categoryName;
  String? get getCreatedDate => createdDate;
  String? get getCreatedTime => createdTime;

  // copyWith
  CategoryData copyWith({
    String? categoryId,
    String? categoryName,
    String? createdDate,
    String? createdTime,
  }) {
    return CategoryData(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  factory CategoryData.fromJson(Map<String, dynamic> json) => _$CategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}

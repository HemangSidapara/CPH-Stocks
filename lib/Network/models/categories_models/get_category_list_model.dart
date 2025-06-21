import 'package:json_annotation/json_annotation.dart';

part 'get_category_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetCategoryListModel {
  String? code;
  String? msg;
  List<CategoryData>? data;

  GetCategoryListModel({
    this.code,
    this.msg,
    this.data,
  });

  factory GetCategoryListModel.fromJson(Map<String, dynamic> json) => _$GetCategoryListModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetCategoryListModelToJson(this);

  GetCategoryListModel copyWith({
    String? code,
    String? msg,
    List<CategoryData>? data,
  }) {
    return GetCategoryListModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class CategoryData {
  String? categoryId;
  String? categoryName;
  String? categoryPrice;
  String? orderNo;
  String? createdDate;
  String? createdTime;

  CategoryData({
    this.categoryId,
    this.categoryName,
    this.categoryPrice,
    this.orderNo,
    this.createdDate,
    this.createdTime,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => _$CategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);

  CategoryData copyWith({
    String? categoryId,
    String? categoryName,
    String? categoryPrice,
    String? orderNo,
    String? createdDate,
    String? createdTime,
  }) {
    return CategoryData(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryPrice: categoryPrice ?? this.categoryPrice,
      orderNo: orderNo ?? this.orderNo,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}

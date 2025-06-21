import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_order_sequence_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetOrderSequenceModel {
  String? code;
  String? msg;
  List<PvdColorGroup>? data;

  GetOrderSequenceModel({this.code, this.msg, this.data});

  factory GetOrderSequenceModel.fromJson(Map<String, dynamic> json) => _$GetOrderSequenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrderSequenceModelToJson(this);

  GetOrderSequenceModel copyWith({String? code, String? msg, List<PvdColorGroup>? data}) {
    return GetOrderSequenceModel(code: code ?? this.code, msg: msg ?? this.msg, data: data ?? this.data);
  }
}

@JsonSerializable(explicitToJson: true)
class PvdColorGroup {
  String? pvdColor;
  List<OrderItem>? orders;

  PvdColorGroup({this.pvdColor, this.orders});

  factory PvdColorGroup.fromJson(Map<String, dynamic> json) => _$PvdColorGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PvdColorGroupToJson(this);

  PvdColorGroup copyWith({String? pvdColor, List<OrderItem>? orders}) {
    return PvdColorGroup(pvdColor: pvdColor ?? this.pvdColor, orders: orders ?? this.orders);
  }
}

@JsonSerializable()
class OrderItem {
  String? orderId;
  String? partyName;
  String? orderMetaId;
  String? userId;
  String? categoryId;
  String? categoryPrice;
  @JsonKey(fromJson: getImage)
  String? itemImage;
  String? itemName;
  String? size;
  String? quantity;
  String? pvdColor;
  String? pending;
  String? status;
  String? createdDate;
  String? createdTime;
  String? categoryName;
  String? description;

  OrderItem({
    this.orderId,
    this.partyName,
    this.orderMetaId,
    this.userId,
    this.categoryId,
    this.categoryPrice,
    this.itemImage,
    this.itemName,
    this.size,
    this.quantity,
    this.pvdColor,
    this.pending,
    this.status,
    this.createdDate,
    this.createdTime,
    this.categoryName,
    this.description,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  OrderItem copyWith({
    String? orderId,
    String? partyName,
    String? orderMetaId,
    String? userId,
    String? categoryId,
    String? categoryPrice,
    String? itemImage,
    String? itemName,
    String? size,
    String? quantity,
    String? pvdColor,
    String? pending,
    String? status,
    String? createdDate,
    String? createdTime,
    String? categoryName,
    String? description,
  }) {
    return OrderItem(
      orderId: orderId ?? this.orderId,
      partyName: partyName ?? this.partyName,
      orderMetaId: orderMetaId ?? this.orderMetaId,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      categoryPrice: categoryPrice ?? this.categoryPrice,
      itemImage: itemImage ?? this.itemImage,
      itemName: itemName ?? this.itemName,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      pvdColor: pvdColor ?? this.pvdColor,
      pending: pending ?? this.pending,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
    );
  }

  static String? getImage(String? value) {
    if (value == null || value.isEmpty == true) {
      return null;
    }
    return value.isURL ? value : ApiUrls.imageBaseUrl + value;
  }
}

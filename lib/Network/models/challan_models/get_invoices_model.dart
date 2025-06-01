import 'package:json_annotation/json_annotation.dart';

part 'get_invoices_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetInvoicesModel {
  String? code;
  String? msg;
  List<OrderInvoice>? data;

  GetInvoicesModel({this.code, this.msg, this.data});

  factory GetInvoicesModel.fromJson(Map<String, dynamic> json) => _$GetInvoicesModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetInvoicesModelToJson(this);

  GetInvoicesModel copyWith({
    String? code,
    String? msg,
    List<OrderInvoice>? data,
  }) {
    return GetInvoicesModel(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class OrderInvoice {
  String? orderInvoiceId;
  String? partyName;
  String? createdDate;
  String? createdTime;
  String? challanNumber;
  List<InvoiceMeta>? invoiceMeta;

  OrderInvoice({
    this.orderInvoiceId,
    this.partyName,
    this.createdDate,
    this.createdTime,
    this.challanNumber,
    this.invoiceMeta,
  });

  factory OrderInvoice.fromJson(Map<String, dynamic> json) => _$OrderInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInvoiceToJson(this);

  OrderInvoice copyWith({
    String? orderInvoiceId,
    String? partyName,
    String? createdDate,
    String? createdTime,
    String? challanNumber,
    List<InvoiceMeta>? invoiceMeta,
  }) {
    return OrderInvoice(
      orderInvoiceId: orderInvoiceId ?? this.orderInvoiceId,
      partyName: partyName ?? this.partyName,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
      challanNumber: challanNumber ?? this.challanNumber,
      invoiceMeta: invoiceMeta ?? this.invoiceMeta,
    );
  }
}

@JsonSerializable()
class InvoiceMeta {
  String? invoiceMetaId;
  String? orderInvoiceId;
  String? serialNumber;
  String? categoryName;
  String? pvdColor;
  String? itemName;
  String? inDate;
  String? quantity;
  String? previous;
  String? okPcs;
  String? woProcess;
  String? inch;
  String? totalInch;
  String? balanceQuantity;
  String? totalAmount;
  String? categoryId;
  @StringFromNumConverter()
  String? categoryPrice;

  InvoiceMeta({
    this.invoiceMetaId,
    this.orderInvoiceId,
    this.serialNumber,
    this.categoryName,
    this.pvdColor,
    this.itemName,
    this.inDate,
    this.quantity,
    this.previous,
    this.okPcs,
    this.woProcess,
    this.inch,
    this.totalInch,
    this.balanceQuantity,
    this.totalAmount,
    this.categoryId,
    this.categoryPrice,
  });

  factory InvoiceMeta.fromJson(Map<String, dynamic> json) => _$InvoiceMetaFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceMetaToJson(this);

  InvoiceMeta copyWith({
    String? invoiceMetaId,
    String? orderInvoiceId,
    String? serialNumber,
    String? categoryName,
    String? pvdColor,
    String? itemName,
    String? inDate,
    String? quantity,
    String? previous,
    String? okPcs,
    String? woProcess,
    String? inch,
    String? totalInch,
    String? balanceQuantity,
    String? totalAmount,
    String? categoryId,
    String? categoryPrice,
  }) {
    return InvoiceMeta(
      invoiceMetaId: invoiceMetaId ?? this.invoiceMetaId,
      orderInvoiceId: orderInvoiceId ?? this.orderInvoiceId,
      serialNumber: serialNumber ?? this.serialNumber,
      categoryName: categoryName ?? this.categoryName,
      pvdColor: pvdColor ?? this.pvdColor,
      itemName: itemName ?? this.itemName,
      inDate: inDate ?? this.inDate,
      quantity: quantity ?? this.quantity,
      previous: previous ?? this.previous,
      okPcs: okPcs ?? this.okPcs,
      woProcess: woProcess ?? this.woProcess,
      inch: inch ?? this.inch,
      totalInch: totalInch ?? this.totalInch,
      balanceQuantity: balanceQuantity ?? this.balanceQuantity,
      totalAmount: totalAmount ?? this.totalAmount,
      categoryId: categoryId ?? this.categoryId,
      categoryPrice: categoryPrice ?? this.categoryPrice,
    );
  }
}

class StringFromNumConverter implements JsonConverter<String?, dynamic> {
  const StringFromNumConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    return json.toString();
  }

  @override
  dynamic toJson(String? object) => object;
}

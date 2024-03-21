import 'dart:convert';

/// code : "200"
/// msg : "Get Orders Successfully"
/// Data : [{"orderId":"1","partyName":"Test","model_meta":[{"orderMetaId":"1","itemName":"Handle","size":"4","quantity":"12","pvdColor":"Silver"},{"orderMetaId":"2","itemName":"Nut Ball","size":"4","quantity":"12","pvdColor":"Black"},{"orderMetaId":"4","itemName":"Handle","size":"4","quantity":"12","pvdColor":"Silver"},{"orderMetaId":"5","itemName":"Nut Ball","size":"4","quantity":"12","pvdColor":"Black"}]},{"orderId":"2","partyName":"Test1","model_meta":[{"orderMetaId":"3","itemName":"gauge","size":"8","quantity":"100","pvdColor":"rose"}]}]

GetOrdersModel getOrdersModelFromJson(String str) => GetOrdersModel.fromJson(json.decode(str));
String getOrdersModelToJson(GetOrdersModel data) => json.encode(data.toJson());

class GetOrdersModel {
  GetOrdersModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetOrdersModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _code;
  String? _msg;
  List<Data>? _data;
  GetOrdersModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetOrdersModel(
        code: code ?? _code,
        msg: msg ?? _msg,
        data: data ?? _data,
      );
  String? get code => _code;
  String? get msg => _msg;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    if (_data != null) {
      map['Data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// orderId : "1"
/// partyName : "Test"
/// model_meta : [{"orderMetaId":"1","itemName":"Handle","size":"4","quantity":"12","pvdColor":"Silver"},{"orderMetaId":"2","itemName":"Nut Ball","size":"4","quantity":"12","pvdColor":"Black"},{"orderMetaId":"4","itemName":"Handle","size":"4","quantity":"12","pvdColor":"Silver"},{"orderMetaId":"5","itemName":"Nut Ball","size":"4","quantity":"12","pvdColor":"Black"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? orderId,
    String? partyName,
    List<ModelMeta>? modelMeta,
  }) {
    _orderId = orderId;
    _partyName = partyName;
    _modelMeta = modelMeta;
  }

  Data.fromJson(dynamic json) {
    _orderId = json['orderId'];
    _partyName = json['partyName'];
    if (json['model_meta'] != null) {
      _modelMeta = [];
      json['model_meta'].forEach((v) {
        _modelMeta?.add(ModelMeta.fromJson(v));
      });
    }
  }
  String? _orderId;
  String? _partyName;
  List<ModelMeta>? _modelMeta;
  Data copyWith({
    String? orderId,
    String? partyName,
    List<ModelMeta>? modelMeta,
  }) =>
      Data(
        orderId: orderId ?? _orderId,
        partyName: partyName ?? _partyName,
        modelMeta: modelMeta ?? _modelMeta,
      );
  String? get orderId => _orderId;
  String? get partyName => _partyName;
  List<ModelMeta>? get modelMeta => _modelMeta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderId'] = _orderId;
    map['partyName'] = _partyName;
    if (_modelMeta != null) {
      map['model_meta'] = _modelMeta?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// orderMetaId : "1"
/// itemName : "Handle"
/// size : "4"
/// quantity : "12"
/// pvdColor : "Silver"

ModelMeta modelMetaFromJson(String str) => ModelMeta.fromJson(json.decode(str));
String modelMetaToJson(ModelMeta data) => json.encode(data.toJson());

class ModelMeta {
  ModelMeta({
    String? orderMetaId,
    String? itemName,
    String? size,
    String? quantity,
    String? pvdColor,
    String? itemImage,
    String? pending,
    String? okPcs,
    String? woProcess,
  }) {
    _orderMetaId = orderMetaId;
    _itemName = itemName;
    _size = size;
    _quantity = quantity;
    _pvdColor = pvdColor;
    _itemImage = itemImage;
    _pending = pending;
    _okPcs = okPcs;
    _woProcess = woProcess;
  }

  ModelMeta.fromJson(dynamic json) {
    _orderMetaId = json['orderMetaId'];
    _itemName = json['itemName'];
    _size = json['size'];
    _quantity = json['quantity'];
    _pvdColor = json['pvdColor'];
    _itemImage = json['itemImage'];
    _pending = json['pending'];
    _okPcs = json['okPcs'];
    _woProcess = json['woProcess'];
  }
  String? _orderMetaId;
  String? _itemName;
  String? _size;
  String? _quantity;
  String? _pvdColor;
  String? _itemImage;
  String? _pending;
  String? _okPcs;
  String? _woProcess;
  ModelMeta copyWith({
    String? orderMetaId,
    String? itemName,
    String? size,
    String? quantity,
    String? pvdColor,
    String? itemImage,
    String? pending,
    String? okPcs,
    String? woProcess,
  }) =>
      ModelMeta(
        orderMetaId: orderMetaId ?? _orderMetaId,
        itemName: itemName ?? _itemName,
        size: size ?? _size,
        quantity: quantity ?? _quantity,
        pvdColor: pvdColor ?? _pvdColor,
        itemImage: itemImage ?? _itemImage,
        pending: pending ?? _pending,
        okPcs: okPcs ?? _okPcs,
        woProcess: woProcess ?? _woProcess,
      );
  String? get orderMetaId => _orderMetaId;
  String? get itemName => _itemName;
  String? get size => _size;
  String? get quantity => _quantity;
  String? get pvdColor => _pvdColor;
  String? get itemImage => _itemImage;
  String? get pending => _pending;
  String? get okPcs => _okPcs;
  String? get woProcess => _woProcess;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderMetaId'] = _orderMetaId;
    map['itemName'] = _itemName;
    map['size'] = _size;
    map['quantity'] = _quantity;
    map['pvdColor'] = _pvdColor;
    map['itemImage'] = _itemImage;
    map['pending'] = _pending;
    map['okPcs'] = _okPcs;
    map['woProcess'] = _woProcess;
    return map;
  }
}

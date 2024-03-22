import 'dart:convert';

/// code : "200"
/// msg : "Get Invoices Successfully"
/// Data : [{"orderId":"1","partyName":"Test","model_meta":[{"orderMetaId":"1","itemName":"Handle","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"2","itemName":"Nut Ball","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"4","itemName":"Handle","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"5","itemName":"Nut Ball","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"}]},{"orderId":"2","partyName":"Test1","model_meta":[{"orderMetaId":"3","itemName":"gauge","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"}]},{"orderId":"3","partyName":"IMP","model_meta":[{"orderMetaId":"24","itemName":"fr","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"31","itemName":"xhn","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"}]}]

ChallanModel challanModelFromJson(String str) => ChallanModel.fromJson(json.decode(str));
String challanModelToJson(ChallanModel data) => json.encode(data.toJson());

class ChallanModel {
  ChallanModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  ChallanModel.fromJson(dynamic json) {
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
  ChallanModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      ChallanModel(
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
/// model_meta : [{"orderMetaId":"1","itemName":"Handle","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"2","itemName":"Nut Ball","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"4","itemName":"Handle","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"5","itemName":"Nut Ball","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"}]

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
/// invoice : "https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"

ModelMeta modelMetaFromJson(String str) => ModelMeta.fromJson(json.decode(str));
String modelMetaToJson(ModelMeta data) => json.encode(data.toJson());

class ModelMeta {
  ModelMeta({
    String? orderMetaId,
    String? itemName,
    String? invoice,
  }) {
    _orderMetaId = orderMetaId;
    _itemName = itemName;
    _invoice = invoice;
  }

  ModelMeta.fromJson(dynamic json) {
    _orderMetaId = json['orderMetaId'];
    _itemName = json['itemName'];
    _invoice = json['invoice'];
  }
  String? _orderMetaId;
  String? _itemName;
  String? _invoice;
  ModelMeta copyWith({
    String? orderMetaId,
    String? itemName,
    String? invoice,
  }) =>
      ModelMeta(
        orderMetaId: orderMetaId ?? _orderMetaId,
        itemName: itemName ?? _itemName,
        invoice: invoice ?? _invoice,
      );
  String? get orderMetaId => _orderMetaId;
  String? get itemName => _itemName;
  String? get invoice => _invoice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderMetaId'] = _orderMetaId;
    map['itemName'] = _itemName;
    map['invoice'] = _invoice;
    return map;
  }
}

import 'dart:convert';

/// code : "200"
/// msg : "Get Invoices Successfully"
/// Data : [{"orderId":"1","partyName":"Test","model_meta":[{"orderMetaId":"1","itemName":"Handle","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"2","itemName":"Nut Ball","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"4","itemName":"Handle","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"5","itemName":"Nut Ball","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"}]},{"orderId":"2","partyName":"Test1","model_meta":[{"orderMetaId":"3","itemName":"gauge","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"}]},{"orderId":"3","partyName":"IMP","model_meta":[{"orderMetaId":"24","itemName":"fr","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"},{"orderMetaId":"31","itemName":"xhn","invoice":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Invoices/35.pdf"}]}]

GetInvoicesModel getInvoicesModelFromJson(String str) => GetInvoicesModel.fromJson(json.decode(str));

String getInvoicesModelToJson(GetInvoicesModel data) => json.encode(data.toJson());

class GetInvoicesModel {
  GetInvoicesModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetInvoicesModel.fromJson(dynamic json) {
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

  GetInvoicesModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetInvoicesModel(
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
    String? contactNumber,
    List<ModelMeta>? modelMeta,
  }) {
    _orderId = orderId;
    _partyName = partyName;
    _contactNumber = contactNumber;
    _modelMeta = modelMeta;
  }

  Data.fromJson(dynamic json) {
    _orderId = json['orderId'];
    _partyName = json['partyName'];
    _contactNumber = json['contactNumber'];
    if (json['model_meta'] != null) {
      _modelMeta = [];
      json['model_meta'].forEach((v) {
        _modelMeta?.add(ModelMeta.fromJson(v));
      });
    }
  }

  String? _orderId;
  String? _partyName;
  String? _contactNumber;
  List<ModelMeta>? _modelMeta;

  Data copyWith({
    String? orderId,
    String? partyName,
    String? contactNumber,
    List<ModelMeta>? modelMeta,
  }) =>
      Data(
        orderId: orderId ?? _orderId,
        partyName: partyName ?? _partyName,
        contactNumber: contactNumber ?? _contactNumber,
        modelMeta: modelMeta ?? _modelMeta,
      );

  String? get orderId => _orderId;

  String? get partyName => _partyName;

  String? get contactNumber => _contactNumber;

  List<ModelMeta>? get modelMeta => _modelMeta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderId'] = _orderId;
    map['partyName'] = _partyName;
    map['contactNumber'] = _contactNumber;
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
    String? orderId,
    String? invoice,
    String? createdDate,
  }) {
    _orderMetaId = orderMetaId;
    _orderId = orderId;
    _invoice = invoice;
    _createdDate = createdDate;
  }

  ModelMeta.fromJson(dynamic json) {
    _orderMetaId = json['orderMetaId'];
    _orderId = json['orderId'];
    _invoice = json['invoice'];
    _createdDate = json['createdDate'];
  }

  String? _orderMetaId;
  String? _orderId;
  String? _invoice;
  String? _createdDate;

  ModelMeta copyWith({
    String? orderMetaId,
    String? orderId,
    String? invoice,
    String? createdDate,
  }) =>
      ModelMeta(
        orderMetaId: orderMetaId ?? _orderMetaId,
        orderId: orderId ?? _orderId,
        invoice: invoice ?? _invoice,
        createdDate: createdDate ?? _createdDate,
      );

  String? get orderMetaId => _orderMetaId;

  String? get orderId => _orderId;

  String? get invoice => _invoice;

  String? get createdDate => _createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderMetaId'] = _orderMetaId;
    map['itemName'] = _orderId;
    map['invoice'] = _invoice;
    map['createdDate'] = _createdDate;
    return map;
  }
}

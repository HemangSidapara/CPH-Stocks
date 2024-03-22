import 'dart:convert';

/// code : "200"
/// msg : "Get Parties Successfully"
/// Data : [{"orderId":"1","partyName":"Test"}]

GetPartiesModel getPartiesModelFromJson(String str) => GetPartiesModel.fromJson(json.decode(str));
String getPartiesModelToJson(GetPartiesModel data) => json.encode(data.toJson());

class GetPartiesModel {
  GetPartiesModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetPartiesModel.fromJson(dynamic json) {
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
  GetPartiesModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetPartiesModel(
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? orderId,
    String? partyName,
    String? contactNumber,
  }) {
    _orderId = orderId;
    _partyName = partyName;
    _contactNumber = contactNumber;
  }

  Data.fromJson(dynamic json) {
    _orderId = json['orderId'];
    _partyName = json['partyName'];
    _contactNumber = json['contactNumber'];
  }
  String? _orderId;
  String? _partyName;
  String? _contactNumber;
  Data copyWith({
    String? orderId,
    String? partyName,
    String? contactNumber,
  }) =>
      Data(
        orderId: orderId ?? _orderId,
        partyName: partyName ?? _partyName,
        contactNumber: contactNumber ?? _contactNumber,
      );
  String? get orderId => _orderId;
  String? get partyName => _partyName;
  String? get contactNumber => _contactNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderId'] = _orderId;
    map['partyName'] = _partyName;
    map['contactNumber'] = _contactNumber;
    return map;
  }
}

import 'dart:convert';

/// code : "200"
/// msg : "Get inAppUpdate Successfully"
/// Data : [{"inAppUpdateId":"1","appUrl":"https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Build/cph_stocks_v1.0.4.apk","appVersion":"1.0.5","createdDate":"2024-04-03 01:42:02"}]

GetLatestVersionModel getLatestVersionModelFromJson(String str) => GetLatestVersionModel.fromJson(json.decode(str));
String getLatestVersionModelToJson(GetLatestVersionModel data) => json.encode(data.toJson());

class GetLatestVersionModel {
  GetLatestVersionModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetLatestVersionModel.fromJson(dynamic json) {
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
  GetLatestVersionModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetLatestVersionModel(
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

/// inAppUpdateId : "1"
/// appUrl : "https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/Build/cph_stocks_v1.0.4.apk"
/// appVersion : "1.0.5"
/// createdDate : "2024-04-03 01:42:02"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? inAppUpdateId,
    String? appUrl,
    String? appVersion,
    String? createdDate,
  }) {
    _inAppUpdateId = inAppUpdateId;
    _appUrl = appUrl;
    _appVersion = appVersion;
    _createdDate = createdDate;
  }

  Data.fromJson(dynamic json) {
    _inAppUpdateId = json['inAppUpdateId'];
    _appUrl = json['appUrl'];
    _appVersion = json['appVersion'];
    _createdDate = json['createdDate'];
  }
  String? _inAppUpdateId;
  String? _appUrl;
  String? _appVersion;
  String? _createdDate;
  Data copyWith({
    String? inAppUpdateId,
    String? appUrl,
    String? appVersion,
    String? createdDate,
  }) =>
      Data(
        inAppUpdateId: inAppUpdateId ?? _inAppUpdateId,
        appUrl: appUrl ?? _appUrl,
        appVersion: appVersion ?? _appVersion,
        createdDate: createdDate ?? _createdDate,
      );
  String? get inAppUpdateId => _inAppUpdateId;
  String? get appUrl => _appUrl;
  String? get appVersion => _appVersion;
  String? get createdDate => _createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inAppUpdateId'] = _inAppUpdateId;
    map['appUrl'] = _appUrl;
    map['appVersion'] = _appVersion;
    map['createdDate'] = _createdDate;
    return map;
  }
}

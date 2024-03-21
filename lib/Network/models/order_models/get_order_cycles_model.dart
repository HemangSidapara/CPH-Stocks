import 'dart:convert';

/// code : "200"
/// msg : "Get Order Cycles Successfully"
/// Data : [{"pending":"20","okPcs":"20","woProcess":"10","invoice":""},{"pending":"10","okPcs":"5","woProcess":"5","invoice":""},{"pending":"0","okPcs":"10","woProcess":"0","invoice":""}]

GetOrderCyclesModel getOrderCyclesModelFromJson(String str) => GetOrderCyclesModel.fromJson(json.decode(str));
String getOrderCyclesModelToJson(GetOrderCyclesModel data) => json.encode(data.toJson());

class GetOrderCyclesModel {
  GetOrderCyclesModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetOrderCyclesModel.fromJson(dynamic json) {
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
  GetOrderCyclesModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetOrderCyclesModel(
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

/// pending : "20"
/// okPcs : "20"
/// woProcess : "10"
/// invoice : ""

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? pending,
    String? okPcs,
    String? woProcess,
    String? invoice,
    String? createdDate,
  }) {
    _pending = pending;
    _okPcs = okPcs;
    _woProcess = woProcess;
    _invoice = invoice;
    _createdDate = createdDate;
  }

  Data.fromJson(dynamic json) {
    _pending = json['pending'];
    _okPcs = json['okPcs'];
    _woProcess = json['woProcess'];
    _invoice = json['invoice'];
    _createdDate = json['createdDate'];
  }
  String? _pending;
  String? _okPcs;
  String? _woProcess;
  String? _invoice;
  String? _createdDate;
  Data copyWith({
    String? pending,
    String? okPcs,
    String? woProcess,
    String? invoice,
    String? createdDate,
  }) =>
      Data(
        pending: pending ?? _pending,
        okPcs: okPcs ?? _okPcs,
        woProcess: woProcess ?? _woProcess,
        invoice: invoice ?? _invoice,
        createdDate: createdDate ?? _createdDate,
      );
  String? get pending => _pending;
  String? get okPcs => _okPcs;
  String? get woProcess => _woProcess;
  String? get invoice => _invoice;
  String? get createdDate => _createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pending'] = _pending;
    map['okPcs'] = _okPcs;
    map['woProcess'] = _woProcess;
    map['invoice'] = _invoice;
    map['createdDate'] = _createdDate;
    return map;
  }
}

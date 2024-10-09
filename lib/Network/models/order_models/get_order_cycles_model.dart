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
    String? invoice,
    String? contactNumber,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _invoice = invoice;
    _contactNumber = contactNumber;
    _data = data;
  }

  GetOrderCyclesModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _invoice = json['invoice'];
    _contactNumber = json['contactNumber'];
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  String? _code;
  String? _msg;
  String? _invoice;
  String? _contactNumber;
  List<Data>? _data;

  GetOrderCyclesModel copyWith({
    String? code,
    String? msg,
    String? invoice,
    List<Data>? data,
  }) =>
      GetOrderCyclesModel(
        code: code ?? _code,
        msg: msg ?? _msg,
        invoice: invoice ?? _invoice,
        contactNumber: contactNumber ?? _contactNumber,
        data: data ?? _data,
      );

  String? get code => _code;

  String? get msg => _msg;

  String? get invoice => _invoice;

  String? get contactNumber => _contactNumber;

  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    map['invoice'] = _invoice;
    map['contactNumber'] = _contactNumber;
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
    String? orderCycleId,
    String? pending,
    String? okPcs,
    String? woProcess,
    String? createdDate,
    String? createdBy,
  }) {
    _orderCycleId = orderCycleId;
    _pending = pending;
    _okPcs = okPcs;
    _woProcess = woProcess;
    _createdDate = createdDate;
    _createdBy = createdBy;
  }

  Data.fromJson(dynamic json) {
    _orderCycleId = json['orderCycleId'];
    _pending = json['pending'];
    _okPcs = json['okPcs'];
    _woProcess = json['woProcess'];
    _createdDate = json['createdDate'];
    _createdBy = json['createdBy'];
  }

  String? _orderCycleId;
  String? _pending;
  String? _okPcs;
  String? _woProcess;
  String? _createdDate;
  String? _createdBy;

  Data copyWith({
    String? orderCycleId,
    String? pending,
    String? okPcs,
    String? woProcess,
    String? createdDate,
    String? createdBy,
  }) =>
      Data(
        orderCycleId: orderCycleId ?? _orderCycleId,
        pending: pending ?? _pending,
        okPcs: okPcs ?? _okPcs,
        woProcess: woProcess ?? _woProcess,
        createdDate: createdDate ?? _createdDate,
        createdBy: createdBy ?? _createdBy,
      );

  String? get orderCycleId => _orderCycleId;

  String? get pending => _pending;

  String? get okPcs => _okPcs;

  String? get woProcess => _woProcess;

  String? get createdDate => _createdDate;

  String? get createdBy => _createdBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderCycleId'] = _orderCycleId;
    map['pending'] = _pending;
    map['okPcs'] = _okPcs;
    map['woProcess'] = _woProcess;
    map['createdDate'] = _createdDate;
    map['createdBy'] = _createdBy;
    return map;
  }
}

import 'dart:convert';

/// code : "200"
/// msg : "Get Orders Meta Successfully"
/// Data : [{"orderMetaId":"7425","itemImage":"","itemName":"datti","createdBy":"CPH2","size":"1\"","quantity":"70","pvdColor":"Gold","createdDate":"2024-12-21","okPcs":"70","woProcess":"0","pending":"0","orderCycles":[{"orderCycleId":"10701","createdBy":"CPH2","pending":"0","okPcs":"70","woProcess":"0","isLastBilled":false,"challanNumber":"","isDispatched":false,"createdDate":"2024-12-21, 06:35 PM"}]},{"orderMetaId":"7426","itemImage":"","itemName":"damru","createdBy":"CPH2","size":"5.5\"","quantity":"5","pvdColor":"Gold","createdDate":"2024-12-21","okPcs":"5","woProcess":"0","pending":"0","orderCycles":[{"orderCycleId":"10710","createdBy":"CPH2","pending":"0","okPcs":"5","woProcess":"0","isLastBilled":false,"challanNumber":"","isDispatched":false,"createdDate":"2024-12-21, 06:43 PM"}]}]

GetOrdersMetaModel getOrdersMetaModelFromJson(String str) => GetOrdersMetaModel.fromJson(json.decode(str));
String getOrdersMetaModelToJson(GetOrdersMetaModel data) => json.encode(data.toJson());

class GetOrdersMetaModel {
  GetOrdersMetaModel({
    String? code,
    String? msg,
    List<Data>? data,
  }) {
    _code = code;
    _msg = msg;
    _data = data;
  }

  GetOrdersMetaModel.fromJson(dynamic json) {
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
  GetOrdersMetaModel copyWith({
    String? code,
    String? msg,
    List<Data>? data,
  }) =>
      GetOrdersMetaModel(
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

/// orderMetaId : "7425"
/// itemImage : ""
/// itemName : "datti"
/// createdBy : "CPH2"
/// size : "1\""
/// quantity : "70"
/// pvdColor : "Gold"
/// createdDate : "2024-12-21"
/// okPcs : "70"
/// woProcess : "0"
/// pending : "0"
/// orderCycles : [{"orderCycleId":"10701","createdBy":"CPH2","pending":"0","okPcs":"70","woProcess":"0","isLastBilled":false,"challanNumber":"","isDispatched":false,"createdDate":"2024-12-21, 06:35 PM"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? orderMetaId,
    String? itemImage,
    String? itemName,
    String? categoryName,
    String? createdBy,
    String? size,
    String? quantity,
    String? pvdColor,
    String? createdDate,
    String? okPcs,
    String? woProcess,
    String? pending,
    List<OrderCycles>? orderCycles,
  }) {
    _orderMetaId = orderMetaId;
    _itemImage = itemImage;
    _itemName = itemName;
    _categoryName = categoryName;
    _createdBy = createdBy;
    _size = size;
    _quantity = quantity;
    _pvdColor = pvdColor;
    _createdDate = createdDate;
    _okPcs = okPcs;
    _woProcess = woProcess;
    _pending = pending;
    _orderCycles = orderCycles;
  }

  Data.fromJson(dynamic json) {
    _orderMetaId = json['orderMetaId'];
    _itemImage = json['itemImage'];
    _itemName = json['itemName'];
    _categoryName = json['categoryName'];
    _createdBy = json['createdBy'];
    _size = json['size'];
    _quantity = json['quantity'];
    _pvdColor = json['pvdColor'];
    _createdDate = json['createdDate'];
    _okPcs = json['okPcs'];
    _woProcess = json['woProcess'];
    _pending = json['pending'];
    if (json['orderCycles'] != null) {
      _orderCycles = [];
      json['orderCycles'].forEach((v) {
        _orderCycles?.add(OrderCycles.fromJson(v));
      });
    }
  }
  String? _orderMetaId;
  String? _itemImage;
  String? _itemName;
  String? _categoryName;
  String? _createdBy;
  String? _size;
  String? _quantity;
  String? _pvdColor;
  String? _createdDate;
  String? _okPcs;
  String? _woProcess;
  String? _pending;
  List<OrderCycles>? _orderCycles;
  Data copyWith({
    String? orderMetaId,
    String? itemImage,
    String? itemName,
    String? categoryName,
    String? createdBy,
    String? size,
    String? quantity,
    String? pvdColor,
    String? createdDate,
    String? okPcs,
    String? woProcess,
    String? pending,
    List<OrderCycles>? orderCycles,
  }) =>
      Data(
        orderMetaId: orderMetaId ?? _orderMetaId,
        itemImage: itemImage ?? _itemImage,
        itemName: itemName ?? _itemName,
        categoryName: categoryName ?? _categoryName,
        createdBy: createdBy ?? _createdBy,
        size: size ?? _size,
        quantity: quantity ?? _quantity,
        pvdColor: pvdColor ?? _pvdColor,
        createdDate: createdDate ?? _createdDate,
        okPcs: okPcs ?? _okPcs,
        woProcess: woProcess ?? _woProcess,
        pending: pending ?? _pending,
        orderCycles: orderCycles ?? _orderCycles,
      );
  String? get orderMetaId => _orderMetaId;
  String? get itemImage => _itemImage;
  String? get itemName => _itemName;
  String? get createdBy => _createdBy;
  String? get size => _size;
  String? get quantity => _quantity;
  String? get pvdColor => _pvdColor;
  String? get createdDate => _createdDate;
  String? get okPcs => _okPcs;
  String? get woProcess => _woProcess;
  String? get pending => _pending;
  List<OrderCycles>? get orderCycles => _orderCycles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderMetaId'] = _orderMetaId;
    map['itemImage'] = _itemImage;
    map['itemName'] = _itemName;
    map['categoryName'] = _categoryName;
    map['createdBy'] = _createdBy;
    map['size'] = _size;
    map['quantity'] = _quantity;
    map['pvdColor'] = _pvdColor;
    map['createdDate'] = _createdDate;
    map['okPcs'] = _okPcs;
    map['woProcess'] = _woProcess;
    map['pending'] = _pending;
    if (_orderCycles != null) {
      map['orderCycles'] = _orderCycles?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// orderCycleId : "10701"
/// createdBy : "CPH2"
/// pending : "0"
/// okPcs : "70"
/// woProcess : "0"
/// isLastBilled : false
/// challanNumber : ""
/// isDispatched : false
/// createdDate : "2024-12-21, 06:35 PM"

OrderCycles orderCyclesFromJson(String str) => OrderCycles.fromJson(json.decode(str));
String orderCyclesToJson(OrderCycles data) => json.encode(data.toJson());

class OrderCycles {
  OrderCycles({
    String? orderCycleId,
    String? createdBy,
    String? pending,
    String? okPcs,
    String? woProcess,
    bool? isLastBilled,
    String? challanNumber,
    bool? isDispatched,
    String? createdDate,
  }) {
    _orderCycleId = orderCycleId;
    _createdBy = createdBy;
    _pending = pending;
    _okPcs = okPcs;
    _woProcess = woProcess;
    _isLastBilled = isLastBilled;
    _challanNumber = challanNumber;
    _isDispatched = isDispatched;
    _createdDate = createdDate;
  }

  OrderCycles.fromJson(dynamic json) {
    _orderCycleId = json['orderCycleId'];
    _createdBy = json['createdBy'];
    _pending = json['pending'];
    _okPcs = json['okPcs'];
    _woProcess = json['woProcess'];
    _isLastBilled = json['isLastBilled'];
    _challanNumber = json['challanNumber'];
    _isDispatched = json['isDispatched'];
    _createdDate = json['createdDate'];
  }
  String? _orderCycleId;
  String? _createdBy;
  String? _pending;
  String? _okPcs;
  String? _woProcess;
  bool? _isLastBilled;
  String? _challanNumber;
  bool? _isDispatched;
  String? _createdDate;
  OrderCycles copyWith({
    String? orderCycleId,
    String? createdBy,
    String? pending,
    String? okPcs,
    String? woProcess,
    bool? isLastBilled,
    String? challanNumber,
    bool? isDispatched,
    String? createdDate,
  }) =>
      OrderCycles(
        orderCycleId: orderCycleId ?? _orderCycleId,
        createdBy: createdBy ?? _createdBy,
        pending: pending ?? _pending,
        okPcs: okPcs ?? _okPcs,
        woProcess: woProcess ?? _woProcess,
        isLastBilled: isLastBilled ?? _isLastBilled,
        challanNumber: challanNumber ?? _challanNumber,
        isDispatched: isDispatched ?? _isDispatched,
        createdDate: createdDate ?? _createdDate,
      );
  String? get orderCycleId => _orderCycleId;
  String? get createdBy => _createdBy;
  String? get pending => _pending;
  String? get okPcs => _okPcs;
  String? get woProcess => _woProcess;
  bool? get isLastBilled => _isLastBilled;
  String? get challanNumber => _challanNumber;
  bool? get isDispatched => _isDispatched;
  String? get createdDate => _createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderCycleId'] = _orderCycleId;
    map['createdBy'] = _createdBy;
    map['pending'] = _pending;
    map['okPcs'] = _okPcs;
    map['woProcess'] = _woProcess;
    map['isLastBilled'] = _isLastBilled;
    map['challanNumber'] = _challanNumber;
    map['isDispatched'] = _isDispatched;
    map['createdDate'] = _createdDate;
    return map;
  }
}

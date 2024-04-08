import 'dart:convert';

/// code : "200"
/// msg : "Get Orders Successfully"
/// partyData : [{"orderId":"1","partyName":"Test","model_meta":[{"orderMetaId":"1","itemName":"Handle","size":"4","quantity":"12","pvdColor":"Silver"},{"orderMetaId":"2","itemName":"Nut Ball","size":"4","quantity":"12","pvdColor":"Black"},{"orderMetaId":"4","itemName":"Handle","size":"4","quantity":"12","pvdColor":"Silver"},{"orderMetaId":"5","itemName":"Nut Ball","size":"4","quantity":"12","pvdColor":"Black"}]},{"orderId":"2","partyName":"Test1","model_meta":[{"orderMetaId":"3","itemName":"gauge","size":"8","quantity":"100","pvdColor":"rose"}]}]
/// colorData: [{"pvdColor":"GODREJ MASTER TONE ","model_meta":[{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"32","itemName":"VMH2059 handle base right matt","size":"6\"","quantity":"13","pvdColor":"godrej master tone ","pending":"13","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"31","itemName":"VMH2063 handle prg Matt ","size":"5.5\"","quantity":"416","pvdColor":"GODREJ MASTER TONE ","pending":"110","createdDate":"2024-04-05","okPcs":"306","woProcess":"0"}]},{"pvdColor":"Gold","model_meta":[{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"10","itemName":"090","size":"896mm","quantity":"6","pvdColor":"Gold","pending":"6","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"6","itemName":"091","size":"896mm","quantity":"20","pvdColor":"Gold","pending":"20","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"9","itemName":"090","size":"448mm","quantity":"2","pvdColor":"Gold","pending":"2","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"7","itemName":"S004 ","size":"3\"","quantity":"15","pvdColor":"Gold","pending":"15","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"8","itemName":"090","size":"160mm","quantity":"13","pvdColor":"Gold","pending":"13","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"17","itemName":"ss cabinet handle","size":"8\"","quantity":"199","pvdColor":"Gold","pending":"199","createdDate":"2024-04-04","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"18","itemName":"ss cabinet handle ","size":"10\"","quantity":"169","pvdColor":"Gold","pending":"169","createdDate":"2024-04-04","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"27","itemName":"phasri","size":"36\"","quantity":"6","pvdColor":"Gold","pending":"6","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"26","itemName":"Patti ","size":"36\"\" ","quantity":"22","pvdColor":"Gold","pending":"22","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"28","itemName":"phasri","size":"18 \" ","quantity":"2","pvdColor":"Gold","pending":"2","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"30","itemName":"patra","size":"3\"","quantity":"15","pvdColor":"Gold","pending":"15","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"29","itemName":"phasri ","size":"7\"","quantity":"13","pvdColor":"Gold","pending":"13","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"25","itemName":"201  c handle ","size":"288 mm ( 12 \" ) ","quantity":"100","pvdColor":"Gold","pending":"100","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"8","partyName":"DOLFIN","contactNumber":"9924160659","orderMetaId":"41","itemName":"Lag","size":"2\u00d71.5","quantity":"58","pvdColor":"Gold","pending":"58","createdDate":"2024-04-06","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"33","itemName":"r. leg matt","size":"1.5\"","quantity":"46","pvdColor":"Gold","pending":"46","createdDate":"2024-04-06","okPcs":"0","woProcess":"0"},{"orderId":"8","partyName":"DOLFIN","contactNumber":"9924160659","orderMetaId":"42","itemName":"Patti","size":"16\"","quantity":"4","pvdColor":"Gold","pending":"4","createdDate":"2024-04-06","okPcs":"0","woProcess":"0"},{"orderId":"8","partyName":"DOLFIN","contactNumber":"9924160659","orderMetaId":"43","itemName":"Patti","size":"22\"","quantity":"2","pvdColor":"Gold","pending":"2","createdDate":"2024-04-06","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"35","itemName":"dhingla ","size":"3\"","quantity":"46","pvdColor":"Gold","pending":"1","createdDate":"2024-04-06","okPcs":"45","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"34","itemName":"alu. pipe ","size":"9.5\"","quantity":"23","pvdColor":"Gold","pending":"0","createdDate":"2024-04-06","okPcs":"23","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"55","itemName":"Lag","size":"1.5\"","quantity":"90","pvdColor":"Gold","pending":"90","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"10","partyName":"DHARMAGBHAI","contactNumber":"7383705906","orderMetaId":"48","itemName":"HANDLE ","size":"5\"","quantity":"1","pvdColor":"Gold","pending":"1","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"76","itemName":"nal part","size":"6x5","quantity":"6","pvdColor":"Gold","pending":"6","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"77","itemName":"nal part","size":"3x1.5","quantity":"25","pvdColor":"Gold","pending":"25","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"78","itemName":"nal ring","size":"1.5","quantity":"19","pvdColor":"Gold","pending":"19","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"75","itemName":"nal part","size":"8x5","quantity":"12","pvdColor":"Gold","pending":"12","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"}]},{"pvdColor":"Rosegold","model_meta":[{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"4","itemName":"088","size":"896mm","quantity":"30","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-02","okPcs":"0","woProcess":"1"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"23","itemName":"S009  Patra ","size":"896mm. ( 24 \"\") ","quantity":"20","pvdColor":"Rosegold","pending":"20","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"38","itemName":"dhingla","size":"3\"","quantity":"80","pvdColor":"Rosegold","pending":"5","createdDate":"2024-04-06","okPcs":"10","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"36","itemName":"ss handle ","size":"22\"","quantity":"10","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"2","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"37","itemName":"ss handle","size":"16\"","quantity":"10","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"4","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"39","itemName":"dhingli","size":"1.5\"","quantity":"80","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"80","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"44","itemName":"087","size":"160mm","quantity":"150","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"15","woProcess":"5"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"45","itemName":"091","size":"448mm","quantity":"30","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"30","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"69","itemName":"087(Patti)","size":"160mm","quantity":"99","pvdColor":"Rosegold","pending":"99","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"50","itemName":"Lag","size":"1.5\"","quantity":"90","pvdColor":"Rosegold","pending":"90","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"65","itemName":"Cylinder ","size":"90mm","quantity":"74","pvdColor":"Rosegold","pending":"74","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"66","itemName":"Roter ","size":"45mm","quantity":"74","pvdColor":"Rosegold","pending":"74","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"51","itemName":"Matt Lag","size":"1.5\"","quantity":"40","pvdColor":"Rosegold","pending":"40","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"70","itemName":"091(Patti)","size":"576mm","quantity":"33","pvdColor":"Rosegold","pending":"33","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"11","partyName":"DIVYESHBHAI","contactNumber":"7016424438","orderMetaId":"61","itemName":"Bend","size":"40\u00d740","quantity":"30","pvdColor":"Rosegold","pending":"30","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"68","itemName":"089(Handle)","size":"896mm","quantity":"30","pvdColor":"Rosegold","pending":"30","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"56","itemName":"VMH-2040 HANDLE STRIP(REWORK)","size":"6'","quantity":"258","pvdColor":"Rosegold","pending":"258","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"60","itemName":"54mm sc round key(REWORK)","size":"2\u00d72\"","quantity":"227","pvdColor":"Rosegold","pending":"227","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"67","itemName":"knob ","size":"1.5 \"","quantity":"194","pvdColor":"Rosegold","pending":"194","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"57","itemName":"PIPE","size":"13\"","quantity":"14","pvdColor":"Rosegold","pending":"14","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"63","itemName":"CYLINDER Body","size":"60mm","quantity":"139","pvdColor":"Rosegold","pending":"139","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"59","itemName":"54mm sc round conceal (REWORK)","size":"2\u00d72\"","quantity":"125","pvdColor":"Rosegold","pending":"125","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"64","itemName":"Roter ","size":"30mm","quantity":"119","pvdColor":"Rosegold","pending":"119","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"9","partyName":"PRATIKBHAI","contactNumber":"9978853111","orderMetaId":"47","itemName":"Kada","size":"2.5\"","quantity":"11","pvdColor":"Rosegold","pending":"11","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"58","itemName":"PIPE ","size":"9\"","quantity":"11","pvdColor":"Rosegold","pending":"11","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"52","itemName":"Door Handle ","size":"16\"","quantity":"10","pvdColor":"Rosegold","pending":"10","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"53","itemName":"Door Handle ","size":"22\"","quantity":"10","pvdColor":"Rosegold","pending":"10","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"54","itemName":"Door Handle ","size":"22'","quantity":"10","pvdColor":"Rosegold","pending":"10","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"11","partyName":"DIVYESHBHAI","contactNumber":"7016424438","orderMetaId":"62","itemName":"Bend","size":"40\u00d740","quantity":"10","pvdColor":"Rosegold","pending":"10","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"46","itemName":"088","size":"896mm","quantity":"30","pvdColor":"Rosegold","pending":"1","createdDate":"2024-04-07","okPcs":"29","woProcess":"0"},{"orderId":"10","partyName":"DHARMAGBHAI","contactNumber":"7383705906","orderMetaId":"49","itemName":"HANDLE ","size":"5\"","quantity":"1","pvdColor":"Rosegold","pending":"1","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"14","partyName":"shine (rajnibhai)","contactNumber":"9341019998","orderMetaId":"79","itemName":"pipe ","size":"8\"","quantity":"8","pvdColor":"Rosegold","pending":"8","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"14","partyName":"shine (rajnibhai)","contactNumber":"9341019998","orderMetaId":"81","itemName":"cnc leg","size":"1.5","quantity":"8","pvdColor":"Rosegold","pending":"8","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"15","partyName":"MAHADEV STEEL (VIJAYBHAI)","contactNumber":"9426368629","orderMetaId":"84","itemName":"DHINGLA","size":"3\"","quantity":"8","pvdColor":"Rosegold","pending":"8","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"15","partyName":"MAHADEV STEEL (VIJAYBHAI)","contactNumber":"9426368629","orderMetaId":"85","itemName":"LAG","size":"1.5","quantity":"8","pvdColor":"Rosegold","pending":"8","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"72","itemName":"nal part","size":"6x5","quantity":"7","pvdColor":"Rosegold","pending":"7","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"82","itemName":"087 patti","size":"448mm","quantity":"51","pvdColor":"Rosegold","pending":"51","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"18","partyName":"test","contactNumber":"6354173390","orderMetaId":"94","itemName":"i1","size":"2\u00d73","quantity":"560","pvdColor":"Rosegold","pending":"500","createdDate":"2024-04-08","okPcs":"60","woProcess":"0"},{"orderId":"15","partyName":"MAHADEV STEEL (VIJAYBHAI)","contactNumber":"9426368629","orderMetaId":"83","itemName":"pipe","size":"12\"","quantity":"4","pvdColor":"Rosegold","pending":"4","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"14","partyName":"shine (rajnibhai)","contactNumber":"9341019998","orderMetaId":"80","itemName":"laser pipe ","size":"11","quantity":"3","pvdColor":"Rosegold","pending":"3","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"16","partyName":"harsoda int.","contactNumber":"7575095555","orderMetaId":"87","itemName":"mortise round dabbi","size":"2x2","quantity":"3","pvdColor":"Rosegold","pending":"3","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"16","partyName":"harsoda int.","contactNumber":"7575095555","orderMetaId":"86","itemName":"mortise dabbi","size":"2x2","quantity":"29","pvdColor":"Rosegold","pending":"29","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"73","itemName":"nal part","size":"3x1.5","quantity":"26","pvdColor":"Rosegold","pending":"26","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"74","itemName":"nal ring","size":"1.5","quantity":"20","pvdColor":"Rosegold","pending":"20","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"71","itemName":"nal part","size":"8x5","quantity":"13","pvdColor":"Rosegold","pending":"13","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"}]}]

GetOrdersModel getOrdersModelFromJson(String str) => GetOrdersModel.fromJson(json.decode(str));
String getOrdersModelToJson(GetOrdersModel data) => json.encode(data.toJson());

class GetOrdersModel {
  GetOrdersModel({
    String? code,
    String? msg,
    List<PartyData>? partyData,
    List<ColorData>? colorData,
  }) {
    _code = code;
    _msg = msg;
    _partyData = partyData;
    _colorData = colorData;
  }

  GetOrdersModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    if (json['partyData'] != null) {
      _partyData = [];
      json['partyData'].forEach((v) {
        _partyData?.add(PartyData.fromJson(v));
      });
    }
    if (json['colorData'] != null) {
      _colorData = [];
      json['colorData'].forEach((v) {
        _colorData?.add(ColorData.fromJson(v));
      });
    }
  }
  String? _code;
  String? _msg;
  List<PartyData>? _partyData;
  List<ColorData>? _colorData;
  GetOrdersModel copyWith({
    String? code,
    String? msg,
    List<PartyData>? partyData,
  }) =>
      GetOrdersModel(
        code: code ?? _code,
        msg: msg ?? _msg,
        partyData: partyData ?? _partyData,
        colorData: colorData ?? _colorData,
      );
  String? get code => _code;
  String? get msg => _msg;
  List<PartyData>? get partyData => _partyData;
  List<ColorData>? get colorData => _colorData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    if (_partyData != null) {
      map['partyData'] = _partyData?.map((v) => v.toJson()).toList();
    }
    if (_colorData != null) {
      map['colorData'] = _colorData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// orderId : "1"
/// partyName : "Test"
/// model_meta : [{"orderMetaId":"1","itemName":"Handle","size":"4","quantity":"12","pvdColor":"Silver"},{"orderMetaId":"2","itemName":"Nut Ball","size":"4","quantity":"12","pvdColor":"Black"},{"orderMetaId":"4","itemName":"Handle","size":"4","quantity":"12","pvdColor":"Silver"},{"orderMetaId":"5","itemName":"Nut Ball","size":"4","quantity":"12","pvdColor":"Black"}]

PartyData partyDataFromJson(String str) => PartyData.fromJson(json.decode(str));
String partyDataToJson(PartyData partyData) => json.encode(partyData.toJson());

class PartyData {
  PartyData({
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

  PartyData.fromJson(dynamic json) {
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
  PartyData copyWith({
    String? orderId,
    String? partyName,
    String? contactNumber,
    List<ModelMeta>? modelMeta,
  }) =>
      PartyData(
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

/// pvdColor: "GODREJ MASTER TONE "
/// model_meta: [{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"32","itemName":"VMH2059 handle base right matt","size":"6\"","quantity":"13","pvdColor":"godrej master tone ","pending":"13","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"31","itemName":"VMH2063 handle prg Matt ","size":"5.5\"","quantity":"416","pvdColor":"GODREJ MASTER TONE ","pending":"110","createdDate":"2024-04-05","okPcs":"306","woProcess":"0"}]},{"pvdColor":"Gold","model_meta":[{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"10","itemName":"090","size":"896mm","quantity":"6","pvdColor":"Gold","pending":"6","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"6","itemName":"091","size":"896mm","quantity":"20","pvdColor":"Gold","pending":"20","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"9","itemName":"090","size":"448mm","quantity":"2","pvdColor":"Gold","pending":"2","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"7","itemName":"S004 ","size":"3\"","quantity":"15","pvdColor":"Gold","pending":"15","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"8","itemName":"090","size":"160mm","quantity":"13","pvdColor":"Gold","pending":"13","createdDate":"2024-04-02","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"17","itemName":"ss cabinet handle","size":"8\"","quantity":"199","pvdColor":"Gold","pending":"199","createdDate":"2024-04-04","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"18","itemName":"ss cabinet handle ","size":"10\"","quantity":"169","pvdColor":"Gold","pending":"169","createdDate":"2024-04-04","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"27","itemName":"phasri","size":"36\"","quantity":"6","pvdColor":"Gold","pending":"6","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"26","itemName":"Patti ","size":"36\"\" ","quantity":"22","pvdColor":"Gold","pending":"22","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"28","itemName":"phasri","size":"18 \" ","quantity":"2","pvdColor":"Gold","pending":"2","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"30","itemName":"patra","size":"3\"","quantity":"15","pvdColor":"Gold","pending":"15","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"29","itemName":"phasri ","size":"7\"","quantity":"13","pvdColor":"Gold","pending":"13","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"25","itemName":"201  c handle ","size":"288 mm ( 12 \" ) ","quantity":"100","pvdColor":"Gold","pending":"100","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"8","partyName":"DOLFIN","contactNumber":"9924160659","orderMetaId":"41","itemName":"Lag","size":"2\u00d71.5","quantity":"58","pvdColor":"Gold","pending":"58","createdDate":"2024-04-06","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"33","itemName":"r. leg matt","size":"1.5\"","quantity":"46","pvdColor":"Gold","pending":"46","createdDate":"2024-04-06","okPcs":"0","woProcess":"0"},{"orderId":"8","partyName":"DOLFIN","contactNumber":"9924160659","orderMetaId":"42","itemName":"Patti","size":"16\"","quantity":"4","pvdColor":"Gold","pending":"4","createdDate":"2024-04-06","okPcs":"0","woProcess":"0"},{"orderId":"8","partyName":"DOLFIN","contactNumber":"9924160659","orderMetaId":"43","itemName":"Patti","size":"22\"","quantity":"2","pvdColor":"Gold","pending":"2","createdDate":"2024-04-06","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"35","itemName":"dhingla ","size":"3\"","quantity":"46","pvdColor":"Gold","pending":"1","createdDate":"2024-04-06","okPcs":"45","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"34","itemName":"alu. pipe ","size":"9.5\"","quantity":"23","pvdColor":"Gold","pending":"0","createdDate":"2024-04-06","okPcs":"23","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"55","itemName":"Lag","size":"1.5\"","quantity":"90","pvdColor":"Gold","pending":"90","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"10","partyName":"DHARMAGBHAI","contactNumber":"7383705906","orderMetaId":"48","itemName":"HANDLE ","size":"5\"","quantity":"1","pvdColor":"Gold","pending":"1","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"76","itemName":"nal part","size":"6x5","quantity":"6","pvdColor":"Gold","pending":"6","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"77","itemName":"nal part","size":"3x1.5","quantity":"25","pvdColor":"Gold","pending":"25","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"78","itemName":"nal ring","size":"1.5","quantity":"19","pvdColor":"Gold","pending":"19","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"75","itemName":"nal part","size":"8x5","quantity":"12","pvdColor":"Gold","pending":"12","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"}]},{"pvdColor":"Rosegold","model_meta":[{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"4","itemName":"088","size":"896mm","quantity":"30","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-02","okPcs":"0","woProcess":"1"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"23","itemName":"S009  Patra ","size":"896mm. ( 24 \"\") ","quantity":"20","pvdColor":"Rosegold","pending":"20","createdDate":"2024-04-05","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"38","itemName":"dhingla","size":"3\"","quantity":"80","pvdColor":"Rosegold","pending":"5","createdDate":"2024-04-06","okPcs":"10","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"36","itemName":"ss handle ","size":"22\"","quantity":"10","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"2","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"37","itemName":"ss handle","size":"16\"","quantity":"10","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"4","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"39","itemName":"dhingli","size":"1.5\"","quantity":"80","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"80","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"44","itemName":"087","size":"160mm","quantity":"150","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"15","woProcess":"5"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"45","itemName":"091","size":"448mm","quantity":"30","pvdColor":"Rosegold","pending":"0","createdDate":"2024-04-06","okPcs":"30","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"69","itemName":"087(Patti)","size":"160mm","quantity":"99","pvdColor":"Rosegold","pending":"99","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"50","itemName":"Lag","size":"1.5\"","quantity":"90","pvdColor":"Rosegold","pending":"90","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"65","itemName":"Cylinder ","size":"90mm","quantity":"74","pvdColor":"Rosegold","pending":"74","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"66","itemName":"Roter ","size":"45mm","quantity":"74","pvdColor":"Rosegold","pending":"74","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"51","itemName":"Matt Lag","size":"1.5\"","quantity":"40","pvdColor":"Rosegold","pending":"40","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"70","itemName":"091(Patti)","size":"576mm","quantity":"33","pvdColor":"Rosegold","pending":"33","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"11","partyName":"DIVYESHBHAI","contactNumber":"7016424438","orderMetaId":"61","itemName":"Bend","size":"40\u00d740","quantity":"30","pvdColor":"Rosegold","pending":"30","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"68","itemName":"089(Handle)","size":"896mm","quantity":"30","pvdColor":"Rosegold","pending":"30","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"56","itemName":"VMH-2040 HANDLE STRIP(REWORK)","size":"6'","quantity":"258","pvdColor":"Rosegold","pending":"258","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"60","itemName":"54mm sc round key(REWORK)","size":"2\u00d72\"","quantity":"227","pvdColor":"Rosegold","pending":"227","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"67","itemName":"knob ","size":"1.5 \"","quantity":"194","pvdColor":"Rosegold","pending":"194","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"57","itemName":"PIPE","size":"13\"","quantity":"14","pvdColor":"Rosegold","pending":"14","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"63","itemName":"CYLINDER Body","size":"60mm","quantity":"139","pvdColor":"Rosegold","pending":"139","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"7","partyName":"Vittoria","contactNumber":"9687189738","orderMetaId":"59","itemName":"54mm sc round conceal (REWORK)","size":"2\u00d72\"","quantity":"125","pvdColor":"Rosegold","pending":"125","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"12","partyName":"AKSHRATIT","contactNumber":"8160303448","orderMetaId":"64","itemName":"Roter ","size":"30mm","quantity":"119","pvdColor":"Rosegold","pending":"119","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"9","partyName":"PRATIKBHAI","contactNumber":"9978853111","orderMetaId":"47","itemName":"Kada","size":"2.5\"","quantity":"11","pvdColor":"Rosegold","pending":"11","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"58","itemName":"PIPE ","size":"9\"","quantity":"11","pvdColor":"Rosegold","pending":"11","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"52","itemName":"Door Handle ","size":"16\"","quantity":"10","pvdColor":"Rosegold","pending":"10","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"53","itemName":"Door Handle ","size":"22\"","quantity":"10","pvdColor":"Rosegold","pending":"10","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"4","partyName":"sunglobal","contactNumber":"8141803108","orderMetaId":"54","itemName":"Door Handle ","size":"22'","quantity":"10","pvdColor":"Rosegold","pending":"10","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"11","partyName":"DIVYESHBHAI","contactNumber":"7016424438","orderMetaId":"62","itemName":"Bend","size":"40\u00d740","quantity":"10","pvdColor":"Rosegold","pending":"10","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"46","itemName":"088","size":"896mm","quantity":"30","pvdColor":"Rosegold","pending":"1","createdDate":"2024-04-07","okPcs":"29","woProcess":"0"},{"orderId":"10","partyName":"DHARMAGBHAI","contactNumber":"7383705906","orderMetaId":"49","itemName":"HANDLE ","size":"5\"","quantity":"1","pvdColor":"Rosegold","pending":"1","createdDate":"2024-04-07","okPcs":"0","woProcess":"0"},{"orderId":"14","partyName":"shine (rajnibhai)","contactNumber":"9341019998","orderMetaId":"79","itemName":"pipe ","size":"8\"","quantity":"8","pvdColor":"Rosegold","pending":"8","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"14","partyName":"shine (rajnibhai)","contactNumber":"9341019998","orderMetaId":"81","itemName":"cnc leg","size":"1.5","quantity":"8","pvdColor":"Rosegold","pending":"8","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"15","partyName":"MAHADEV STEEL (VIJAYBHAI)","contactNumber":"9426368629","orderMetaId":"84","itemName":"DHINGLA","size":"3\"","quantity":"8","pvdColor":"Rosegold","pending":"8","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"15","partyName":"MAHADEV STEEL (VIJAYBHAI)","contactNumber":"9426368629","orderMetaId":"85","itemName":"LAG","size":"1.5","quantity":"8","pvdColor":"Rosegold","pending":"8","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"72","itemName":"nal part","size":"6x5","quantity":"7","pvdColor":"Rosegold","pending":"7","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"2","partyName":"SUJIN","contactNumber":"9638903576","orderMetaId":"82","itemName":"087 patti","size":"448mm","quantity":"51","pvdColor":"Rosegold","pending":"51","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"18","partyName":"test","contactNumber":"6354173390","orderMetaId":"94","itemName":"i1","size":"2\u00d73","quantity":"560","pvdColor":"Rosegold","pending":"500","createdDate":"2024-04-08","okPcs":"60","woProcess":"0"},{"orderId":"15","partyName":"MAHADEV STEEL (VIJAYBHAI)","contactNumber":"9426368629","orderMetaId":"83","itemName":"pipe","size":"12\"","quantity":"4","pvdColor":"Rosegold","pending":"4","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"14","partyName":"shine (rajnibhai)","contactNumber":"9341019998","orderMetaId":"80","itemName":"laser pipe ","size":"11","quantity":"3","pvdColor":"Rosegold","pending":"3","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"16","partyName":"harsoda int.","contactNumber":"7575095555","orderMetaId":"87","itemName":"mortise round dabbi","size":"2x2","quantity":"3","pvdColor":"Rosegold","pending":"3","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"16","partyName":"harsoda int.","contactNumber":"7575095555","orderMetaId":"86","itemName":"mortise dabbi","size":"2x2","quantity":"29","pvdColor":"Rosegold","pending":"29","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"73","itemName":"nal part","size":"3x1.5","quantity":"26","pvdColor":"Rosegold","pending":"26","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"74","itemName":"nal ring","size":"1.5","quantity":"20","pvdColor":"Rosegold","pending":"20","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"},{"orderId":"13","partyName":"snehalbhai (vavdi)","contactNumber":"9925345633","orderMetaId":"71","itemName":"nal part","size":"8x5","quantity":"13","pvdColor":"Rosegold","pending":"13","createdDate":"2024-04-08","okPcs":"0","woProcess":"0"}]

ColorData colorDataFromJson(String str) => ColorData.fromJson(json.decode(str));
String colorDataToJson(ColorData colorData) => json.encode(colorData.toJson());

class ColorData {
  ColorData({
    String? pvdColor,
    List<ModelMeta>? modelMeta,
  }) {
    _pvdColor = pvdColor;
    _modelMeta = modelMeta;
  }

  ColorData.fromJson(dynamic json) {
    _pvdColor = json['pvdColor'];
    if (json['model_meta'] != null) {
      _modelMeta = [];
      json['model_meta'].forEach((v) {
        _modelMeta?.add(ModelMeta.fromJson(v));
      });
    }
  }
  String? _pvdColor;
  List<ModelMeta>? _modelMeta;
  ColorData copyWith({
    String? pvdColor,
    List<ModelMeta>? modelMeta,
  }) =>
      ColorData(
        pvdColor: pvdColor ?? _pvdColor,
        modelMeta: modelMeta ?? _modelMeta,
      );
  String? get pvdColor => _pvdColor;
  List<ModelMeta>? get modelMeta => _modelMeta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pvdColor'] = _pvdColor;
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
    String? orderId,
    String? partyName,
    String? contactNumber,
    String? orderMetaId,
    String? itemName,
    String? size,
    String? quantity,
    String? pvdColor,
    String? itemImage,
    String? pending,
    String? okPcs,
    String? woProcess,
    String? createdDate,
  }) {
    _orderId = orderId;
    _partyName = partyName;
    _contactNumber = contactNumber;
    _orderMetaId = orderMetaId;
    _itemName = itemName;
    _size = size;
    _quantity = quantity;
    _pvdColor = pvdColor;
    _itemImage = itemImage;
    _pending = pending;
    _okPcs = okPcs;
    _woProcess = woProcess;
    _createdDate = createdDate;
  }

  ModelMeta.fromJson(dynamic json) {
    _orderId = json['orderId'];
    _partyName = json['partyName'];
    _contactNumber = json['contactNumber'];
    _orderMetaId = json['orderMetaId'];
    _itemName = json['itemName'];
    _size = json['size'];
    _quantity = json['quantity'];
    _pvdColor = json['pvdColor'];
    _itemImage = json['itemImage'];
    _pending = json['pending'];
    _okPcs = json['okPcs'];
    _woProcess = json['woProcess'];
    _createdDate = json['createdDate'];
  }
  String? _orderId;
  String? _partyName;
  String? _contactNumber;
  String? _orderMetaId;
  String? _itemName;
  String? _size;
  String? _quantity;
  String? _pvdColor;
  String? _itemImage;
  String? _pending;
  String? _okPcs;
  String? _woProcess;
  String? _createdDate;
  ModelMeta copyWith({
    String? orderId,
    String? partyName,
    String? contactNumber,
    String? orderMetaId,
    String? itemName,
    String? size,
    String? quantity,
    String? pvdColor,
    String? itemImage,
    String? pending,
    String? okPcs,
    String? woProcess,
    String? createdDate,
  }) =>
      ModelMeta(
        orderId: orderId ?? _orderId,
        partyName: partyName ?? _partyName,
        contactNumber: contactNumber ?? _contactNumber,
        orderMetaId: orderMetaId ?? _orderMetaId,
        itemName: itemName ?? _itemName,
        size: size ?? _size,
        quantity: quantity ?? _quantity,
        pvdColor: pvdColor ?? _pvdColor,
        itemImage: itemImage ?? _itemImage,
        pending: pending ?? _pending,
        okPcs: okPcs ?? _okPcs,
        woProcess: woProcess ?? _woProcess,
        createdDate: createdDate ?? _createdDate,
      );
  String? get orderId => _orderId;
  String? get partyName => _partyName;
  String? get contactNumber => _contactNumber;
  String? get orderMetaId => _orderMetaId;
  String? get itemName => _itemName;
  String? get size => _size;
  String? get quantity => _quantity;
  String? get pvdColor => _pvdColor;
  String? get itemImage => _itemImage;
  String? get pending => _pending;
  String? get okPcs => _okPcs;
  String? get woProcess => _woProcess;
  String? get createdDate => _createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderId'] = _orderId;
    map['partyName'] = _partyName;
    map['contactNumber'] = _contactNumber;
    map['orderMetaId'] = _orderMetaId;
    map['itemName'] = _itemName;
    map['size'] = _size;
    map['quantity'] = _quantity;
    map['pvdColor'] = _pvdColor;
    map['itemImage'] = _itemImage;
    map['pending'] = _pending;
    map['okPcs'] = _okPcs;
    map['woProcess'] = _woProcess;
    map['createdDate'] = _createdDate;
    return map;
  }
}

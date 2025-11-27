import 'dart:convert';

/// code : "200"
/// msg : "Login Successfully"
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSIsInBob25lIjoiMTIzNDU2Nzg5MCJ9.1691147851760150006e1a090bbc74456b80d933c7d54ac6fdab45e4c6e0bfec"
/// role : "Admin"

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    String? code,
    String? msg,
    String? token,
    String? phone,
    String? role,
    String? name,
    String? userId,
  }) {
    _code = code;
    _msg = msg;
    _token = token;
    _phone = phone;
    _role = role;
    _name = name;
    _userId = userId;
  }

  LoginModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _token = json['token'] ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSIsInBob25lIjoiMTIzNDU2Nzg5MCJ9.1691147851760150006e1a090bbc74456b80d933c7d54ac6fdab45e4c6e0bfec";
    _phone = json['phone'];
    _role = json['role'];
    _name = json['name'];
    _userId = json['userId'];
  }

  String? _code;
  String? _msg;
  String? _token;
  String? _phone;
  String? _role;
  String? _name;
  String? _userId;

  LoginModel copyWith({
    String? code,
    String? msg,
    String? token,
    String? phone,
    String? role,
    String? name,
    String? userId,
  }) => LoginModel(
    code: code ?? _code,
    msg: msg ?? _msg,
    token: token ?? _token,
    phone: phone ?? _phone,
    role: role ?? _role,
    name: name ?? _name,
    userId: userId ?? _userId,
  );

  String? get code => _code;

  String? get msg => _msg;

  String? get token => _token;

  String? get phone => _phone;

  String? get role => _role;

  String? get name => _name;

  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    map['token'] = _token;
    map['phone'] = _phone;
    map['role'] = _role;
    map['name'] = _name;
    map['userId'] = _userId;
    return map;
  }
}

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
    String? role,
    String? name,
  }) {
    _code = code;
    _msg = msg;
    _token = token;
    _role = role;
    _name = name;
  }

  LoginModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _token = json['token'] ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSIsInBob25lIjoiMTIzNDU2Nzg5MCJ9.1691147851760150006e1a090bbc74456b80d933c7d54ac6fdab45e4c6e0bfec";
    _role = json['role'];
    _name = json['name'];
  }
  String? _code;
  String? _msg;
  String? _token;
  String? _role;
  String? _name;
  LoginModel copyWith({
    String? code,
    String? msg,
    String? token,
    String? role,
    String? name,
  }) =>
      LoginModel(
        code: code ?? _code,
        msg: msg ?? _msg,
        token: token ?? _token,
        role: role ?? _role,
        name: name ?? _name,
      );
  String? get code => _code;
  String? get msg => _msg;
  String? get token => _token;
  String? get role => _role;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    map['token'] = _token;
    map['role'] = _role;
    map['name'] = _name;
    return map;
  }
}

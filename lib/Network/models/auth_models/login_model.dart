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
  }) {
    _code = code;
    _msg = msg;
    _token = token;
    _role = role;
  }

  LoginModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _token = json['token'] ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSIsInBob25lIjoiMTIzNDU2Nzg5MCJ9.1691147851760150006e1a090bbc74456b80d933c7d54ac6fdab45e4c6e0bfec";
    _role = json['role'];
  }
  String? _code;
  String? _msg;
  String? _token;
  String? _role;
  LoginModel copyWith({
    String? code,
    String? msg,
    String? token,
    String? role,
  }) =>
      LoginModel(
        code: code ?? _code,
        msg: msg ?? _msg,
        token: token ?? _token,
        role: role ?? _role,
      );
  String? get code => _code;
  String? get msg => _msg;
  String? get token => _token;
  String? get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    map['token'] = _token;
    map['role'] = _role;
    return map;
  }
}

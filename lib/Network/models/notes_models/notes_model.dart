import 'dart:convert';

/// code : "200"
/// msg : "Get Parties Successfully"
/// Notes : "this is notes"

NotesModel notesModelFromJson(String str) => NotesModel.fromJson(json.decode(str));
String notesModelToJson(NotesModel data) => json.encode(data.toJson());

class NotesModel {
  NotesModel({
    String? code,
    String? msg,
    String? notes,
  }) {
    _code = code;
    _msg = msg;
    _notes = notes;
  }

  NotesModel.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _notes = json['Notes'];
  }
  String? _code;
  String? _msg;
  String? _notes;
  NotesModel copyWith({
    String? code,
    String? msg,
    String? notes,
  }) =>
      NotesModel(
        code: code ?? _code,
        msg: msg ?? _msg,
        notes: notes ?? _notes,
      );
  String? get code => _code;
  String? get msg => _msg;
  String? get notes => _notes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    map['Notes'] = _notes;
    return map;
  }
}

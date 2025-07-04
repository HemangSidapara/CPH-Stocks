import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:dio/dio.dart';

class ResponseModel {
  int? statusCode;
  Response? response;

  ResponseModel({this.statusCode, this.response});

  dynamic get data => response?.data['data'];

  dynamic get message => response?.data?['msg'];

  bool get isSuccess => response != null && response!.statusCode! >= 200 && response!.statusCode! <= 299 && response!.data['code'].toString().toInt() >= 200 && response!.data['code'].toString().toInt() <= 299;

  dynamic getExtraData(String paramName) {
    return response?.data[paramName];
  }
}

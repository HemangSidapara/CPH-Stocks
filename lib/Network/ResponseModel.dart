import 'package:dio/dio.dart';

class ResponseModel {
  int? statusCode;
  Response? response;

  ResponseModel({this.statusCode, this.response});

  get data => response!.data['data'];

  get message => response!.data['message'];

  bool get isSuccess => response!.statusCode! >= 200 && response!.statusCode! <= 299;

  getExtraData(String paramName) {
    return response!.data[paramName];
  }
}

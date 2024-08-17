import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/foundation.dart';

class ChallanService {
  static Future<ResponseModel> getInvoicesService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getInvoicesApi,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getInvoicesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getInvoicesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

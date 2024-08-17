import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/foundation.dart';

class NotesService {
  /// Get Notes
  static Future<ResponseModel> getNotesService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getNotesApi,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getNotesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getNotesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Edit Notes
  static Future<ResponseModel> editNotesService({required String notes}) async {
    final params = {
      ApiKeys.notes: notes,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.editNotesApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("editNotesApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("editNotesApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

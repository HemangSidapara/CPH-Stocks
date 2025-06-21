import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/api_base_helper.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:flutter/foundation.dart';

class CategoriesServices {
  /// Get Categories Service
  static Future<ResponseModel> getCategoriesService() async {
    final response = await ApiBaseHelper.getHTTP(
      ApiUrls.getCategoryListApi,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("getCategoryListApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("getCategoryListApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("getCategoryListApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Reorder Category Service
  static Future<ResponseModel> reorderCategoryService({
    required List<Map<String, dynamic>> reorderList,
  }) async {
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.reorderCategoryApi,
      params: reorderList,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("reorderCategoryApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("reorderCategoryApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("reorderCategoryApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Create Category Service
  static Future<ResponseModel> createCategoryService({
    required String categoryName,
    required String categoryPrice,
  }) async {
    final params = {
      ApiKeys.categoryName: categoryName,
      ApiKeys.categoryPrice: categoryPrice,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.createCategoryApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("createCategoryApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("createCategoryApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("createCategoryApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }

  /// Edit Category Service
  static Future<ResponseModel> editCategoryService({
    required String categoryId,
    required String categoryName,
    required String categoryPrice,
  }) async {
    final params = {
      ApiKeys.categoryId: categoryId,
      ApiKeys.categoryName: categoryName,
      ApiKeys.categoryPrice: categoryPrice,
    };
    final response = await ApiBaseHelper.postHTTP(
      ApiUrls.editCategoryApi,
      params: params,
      showProgress: false,
      onError: (dioExceptions) {
        if (kDebugMode) {
          print("editCategoryApi onError :: ${dioExceptions.message}");
        }
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          if (kDebugMode) {
            print("editCategoryApi success :: ${res.message}");
          }
        } else {
          if (kDebugMode) {
            print("editCategoryApi error :: ${res.message}");
          }
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}

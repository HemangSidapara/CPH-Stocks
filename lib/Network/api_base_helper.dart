import 'package:cph_stocks/Constants/api_urls.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:cph_stocks/Utils/progress_dialog.dart';
import 'package:cph_stocks/Utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;

class ApiBaseHelper {
  static const String baseUrl = ApiUrls.baseUrl;
  static bool showProgressDialog = true;
  static Stopwatch stopWatch = Stopwatch();

  static BaseOptions opts = BaseOptions(
    baseUrl: baseUrl,
    responseType: ResponseType.json,
    connectTimeout: const Duration(seconds: 45),
    receiveTimeout: const Duration(seconds: 45),
    sendTimeout: const Duration(seconds: 45),
  );

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    ///For Print Logs
    if (!kReleaseMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          error: true,
          responseHeader: true,
        ),
      );
    }

    ///For Show Hide Progress Dialog
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) async {
            if (Get.isSnackbarOpen) {
              await Get.closeCurrentSnackbar();
            }
            if (showProgressDialog) Get.put(ProgressDialog()).showProgressDialog(true);
            Logger.printLog(tag: '|---------------> ${options.method} JSON METHOD <---------------|\n\n REQUEST_URL :', printLog: '\n ${options.uri} \n\n REQUEST_HEADER : ${options.headers}  \n\n REQUEST_DATA : ${options.data.toString()}', logIcon: Logger.info);
            return requestInterceptor(options, handler);
          },
          onResponse: (response, handler) async {
            if (Get.isSnackbarOpen) {
              await Get.closeCurrentSnackbar();
            }
            Get.put(ProgressDialog()).showProgressDialog(false);
            Get.delete<ProgressDialog>();
            showProgressDialog = true;

            if (response.statusCode! >= 100 && response.statusCode! <= 199) {
              Logger.printLog(tag: 'WARNING CODE ${response.statusCode} : ', printLog: response.data.toString(), logIcon: Logger.warning);
            } else {
              Logger.printLog(tag: 'SUCCESS CODE ${response.statusCode} : ', printLog: response.data.toString(), logIcon: Logger.success);
            }

            return handler.next(response);
          },
          onError: (DioException e, handler) async {
            if (Get.isSnackbarOpen) {
              await Get.closeCurrentSnackbar();
            }
            Get.put(ProgressDialog()).showProgressDialog(false);
            Get.delete<ProgressDialog>();
            showProgressDialog = true;

            Logger.printLog(tag: 'ERROR CODE ${e.response?.statusCode} : ', printLog: e.toString(), logIcon: Logger.error);

            return handler.next(e);
          },
        ),
      );
  }

  static dynamic requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get your JWT token

    options.headers.addAll({
      "Authorization": "Bearer ${getData(AppConstance.authorizationToken)}",
    });

    return handler.next(options);
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  static Future<ResponseModel> postHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      Response response = await baseAPI.post(
        url,
        data: params,
        onSendProgress: onSendProgress,
      );
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  static Future<ResponseModel> deleteHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      Response response = await baseAPI.delete(
        url,
        data: params,
      );
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  static Future<ResponseModel> getHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      Response response = await baseAPI.get(url, queryParameters: params);
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  static Future<ResponseModel> putHTTP(
    String url, {
    dynamic data,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      Response response = await baseAPI.put(url, data: data);
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  static Future<ResponseModel> patchHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
    void Function(int count, int total)? onSendProgress,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      Response response = await baseAPI.patch(
        url,
        data: params,
        onSendProgress: onSendProgress,
      );
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  static handleResponse(
    Response response,
    Function(DioExceptions dioExceptions) onError,
    Function(ResponseModel res) onSuccess,
  ) {
    var successModel = ResponseModel(statusCode: response.statusCode, response: response);
    onSuccess(successModel);
    return successModel;
  }

  static handleError(
    DioException e,
    Function(DioExceptions dioExceptions) onError,
    Function(ResponseModel res) onSuccess,
  ) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        var errorModel = ResponseModel(statusCode: e.response!.statusCode, response: e.response);
        onSuccess(errorModel);
        return ResponseModel(statusCode: e.response!.statusCode, response: e.response);
      default:
        onError(DioExceptions.fromDioError(e));
        Utils.handleMessage(message: DioExceptions.fromDioError(e).message, isError: true);
        throw DioExceptions.fromDioError(e).message!;
    }
  }
}

class DioExceptions implements Exception {
  String? message;

  DioExceptions.fromDioError(DioException? dioError) {
    switch (dioError!.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.unknown:
        message = "No internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleResponseError(dioError.response!.statusCode!, dioError.response!.data);
        break;
      case DioException.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleResponseError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error["message"];
      case 500:
        return 'Internal Server Error. Please try again.';
      default:
        return 'Sorry, something went wrong. Please try again.';
    }
  }
}

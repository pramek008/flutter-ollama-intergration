import 'dart:io';
import 'package:dio/dio.dart';

import '../clients/app_services.dart';
import '../clients/locator_injector.dart';
import 'base_response_model.dart';

final logger = locator.get<AppServices>().logger;

getErrorMessage(error) {
  if (error is DioException) {
    if (error.response != null) {
      return error.response!.data['message'];
    }
  }

  return 'Something happened';
}

getErrorBaseResponse(error) {
  print('error: $error');

  if (error is DioException) {
    final Map<String, dynamic> responseMap = {
      "statusCode": -1,
      "result": false,
    };
    print('error.response: ${error.type}');
    print('error.response: ${error.response}');
    print('error.response: ${error.response?.statusCode}');
    if (error.response != null) {
      final response = error.response;
      responseMap["statusCode"] = error.response!.statusCode;
      switch (error.response!.statusCode) {
        case 404:
          logger.e('400 - Not found');
          responseMap["message"] =
              "400 - Not found.\nSomething went wrong while trying to connect with the server, please try again later";
          return BaseResponse<String?>.fromJson(responseMap, (json) {
            return json;
          });
        case 401:
          logger.e('401 - Unauthorized.');
          responseMap["message"] =
              "401 - Unauthorized.\nSomething went wrong while trying to connect with the server, please try again later.";
          return BaseResponse<String?>.fromJson(responseMap, (json) {
            return json;
          });
        case 500:
          logger.e('500 - Internal Server Error.');
          responseMap["message"] =
              "500 - Internal Server Error.\nSomething went wrong while trying to connect with the server, please try again later.";
          return BaseResponse<String?>.fromJson(responseMap, (json) {
            return json;
          });
        case 501:
          logger.e('501 - Not Implemented Server Error.');
          responseMap["message"] =
              "501 - Not Implemented Server Error.\nSomething went wrong while trying to connect with the server, please try again later.";
          return BaseResponse<String?>.fromJson(responseMap, (json) {
            return json;
          });
        case 502:
          logger.e('502 - Bad Gateway Server Error.');
          responseMap["message"] =
              "502 - Bad Gateway Server Error.\nSomething went wrong while trying to connect with the server, please try again later.";
          return BaseResponse<String?>.fromJson(responseMap, (json) {
            return json;
          });
        default:
          logger.e('${response?.statusCode} - ${response?.data}');
          logger.e(
              '${response?.statusCode} - Something went wrong while trying to connect with the server.');
          /*responseMap["message"] = "${error.response!.statusCode} - Something went wrong while trying to connect with the server";
          return BaseResponse<String?>.fromJson(responseMap, (json) {
            return json;
          });*/
          return BaseResponse<String?>.fromJson(response?.data, (json) {
            return json;
          });
      }
    }

    if (error.type == DioExceptionType.connectionTimeout) {
      responseMap["statusCode"] = 408;
      responseMap["message"] =
          "The Request take too long process, please try again";
      return BaseResponse<String?>.fromJson(responseMap, (json) {
        return json;
      });
    }

    if (error.type == DioExceptionType.receiveTimeout) {
      responseMap["statusCode"] = 408;
      responseMap["message"] =
          "Unable to connect to server, please try again later";
      return BaseResponse<String?>.fromJson(responseMap, (json) {
        return json;
      });
    }

    if (error.error is SocketException) {
      responseMap["message"] =
          "There is no internet connection. Please check your internet connection";
      return BaseResponse<String?>.fromJson(responseMap, (json) {
        return json;
      });
    }
  }

  return 'Something happened';
}

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter_ollama_integration/features/chat_room/models/chat_model.dart';

import '../../clients/locator_injector.dart';
import '../../services/secure_storage.dart';

abstract class ChatDatasource {
  Stream<ChatResponseModel> getChatResponseFromServer(
      {required String userInput});
  void abortCurrentRequest();
}

class RemoteChatDatasource implements ChatDatasource {
  final Dio _dio;
  CancelToken? cancelToken;

  RemoteChatDatasource(
    this._dio,
    this.cancelToken,
  );

  @override
  Stream<ChatResponseModel> getChatResponseFromServer(
      {required String userInput}) async* {
    final storageService = locator<SecureStorageImpl>();

    try {
      final baseUrl = await storageService.readBaseUrl();
      final basePort = await storageService.readPort();
      final basePath = await storageService.readCustomPath();
      final baseModel = await storageService.readCustomModel();

      final response = await _dio.post(
        'http://$baseUrl:$basePort$basePath',
        data: {
          "model": baseModel,
          "prompt": userInput,
        },
        options: Options(responseType: ResponseType.stream),
        cancelToken: cancelToken,
      );

      await for (final chunk in response.data.stream) {
        final decodedChunk = utf8.decode(chunk);
        final lines = decodedChunk.split('\n');
        for (var line in lines) {
          if (line.isNotEmpty) {
            final resp = json.decode(line);
            yield ChatResponseModel.fromJson(resp);
          }
        }
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        yield ChatResponseModel(response: "Request cancelled", done: true);
      } else {
        yield ChatResponseModel(response: "Error: ${e.toString()}", done: true);
      }
    }
  }

  @override
  void abortCurrentRequest() {
    cancelToken?.cancel("Request cancelled by user");
  }
}

import 'package:flutter_ollama_integration/features/chat_room/chat_repository.dart';
import 'package:flutter_ollama_integration/features/chat_room/models/chat_model.dart';

class GetChatResponseUsecase {
  final ChatRepository _repository;

  GetChatResponseUsecase(this._repository);

  Stream<ChatResponseModel> executeStream({required String userInput}) {
    return _repository.getChatResponseStream(
      userInput,
    );
  }

  Future<ChatResponseModel> executeNonStream({required String userInput}) {
    return _repository.getChatResponseNonStream(
      userInput,
    );
  }

  void abortRequest() {
    _repository.abortRequest();
  }
}

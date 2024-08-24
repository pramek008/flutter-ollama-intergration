import 'package:flutter_ollama_integration/features/chat_room/chat_repository.dart';
import 'package:flutter_ollama_integration/features/chat_room/models/chat_model.dart';

class GetChatResponseUsecase {
  final ChatRepository _repository;

  GetChatResponseUsecase(this._repository);

  Stream<ChatResponseModel> execute({required String userInput}) {
    return _repository.getChatResponse(userInput);
  }

  void abortRequest() {
    _repository.abortRequest();
  }
}

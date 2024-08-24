import 'package:flutter_ollama_integration/features/chat_room/models/chat_model.dart';
import 'package:flutter_ollama_integration/features/chat_room/remote_chat_datasource.dart';

class ChatRepository {
  final RemoteChatDatasource _datasource;

  ChatRepository(this._datasource);

  Stream<ChatResponseModel> getChatResponse(String userInput) {
    return _datasource.getChatResponseFromServer(userInput: userInput);
  }

  void abortRequest() {
    _datasource.abortCurrentRequest();
  }
}

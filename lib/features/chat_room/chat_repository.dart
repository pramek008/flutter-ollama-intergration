import 'package:flutter_ollama_integration/features/chat_room/models/chat_model.dart';
import 'package:flutter_ollama_integration/features/chat_room/remote_chat_datasource.dart';

class ChatRepository {
  final RemoteChatDatasource _datasource;

  ChatRepository(this._datasource);

  Stream<ChatResponseModel> getChatResponseStream(String userInput) {
    return _datasource.getChatResponseStream(userInput: userInput);
  }

  Future<ChatResponseModel> getChatResponseNonStream(String userInput) async {
    return _datasource.getChatResponseNonStream(userInput: userInput);
  }

  void abortRequest() {
    _datasource.abortCurrentRequest();
  }
}

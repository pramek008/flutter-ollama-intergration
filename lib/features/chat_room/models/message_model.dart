// lib/src/features/chat_feature/domain/Model/chat_message_Model.dart

enum MessageRole { user, ai }

class MessageModel {
  final String message;
  final MessageRole sender;
  final DateTime time;
  MessageModel(
      {required this.message, required this.sender, required this.time});
}

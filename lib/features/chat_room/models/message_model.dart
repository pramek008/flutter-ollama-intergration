// lib/src/features/chat_feature/domain/Model/chat_message_Model.dart

enum MessageSender { user, ai }

class MessageSenderModel {
  final String message;
  final MessageSender sender;

  MessageSenderModel({required this.message, required this.sender});
}

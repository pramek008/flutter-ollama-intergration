part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final bool streamMode;

  const SendMessageEvent(this.message, {this.streamMode = false});

  @override
  List<Object> get props => [message, streamMode];
}

class ReceiveResponseEvent extends ChatEvent {
  final ChatResponseModel response;

  const ReceiveResponseEvent(this.response);

  @override
  List<Object> get props => [response];
}

class AbortRequestEvent extends ChatEvent {}

part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatResponseReceived extends ChatState {
  final ChatResponseModel response;

  const ChatResponseReceived(this.response);

  @override
  List<Object> get props => [response];
}

class ChatLoaded extends ChatState {
  final ChatResponseModel response;

  const ChatLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class ChatAborted extends ChatState {}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object> get props => [error];
}

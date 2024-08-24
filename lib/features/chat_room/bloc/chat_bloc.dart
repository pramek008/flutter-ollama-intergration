import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ollama_integration/features/chat_room/models/chat_model.dart';

import '../chat_response_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatResponseUsecase _getChatResponseUsecase;
  StreamSubscription? _chatSubscription;

  ChatBloc(this._getChatResponseUsecase) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveResponseEvent>(_onReceiveResponse);
    on<AbortRequestEvent>(_onAbortRequest);
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    _chatSubscription?.cancel();
    _chatSubscription =
        _getChatResponseUsecase.execute(userInput: event.message).listen(
              (response) => add(ReceiveResponseEvent(response)),
              onError: (error) => add(ReceiveResponseEvent(
                  ChatResponseModel(response: "Error: $error", done: true))),
            );
  }

  void _onReceiveResponse(ReceiveResponseEvent event, Emitter<ChatState> emit) {
    if (event.response.done!) {
      emit(ChatLoaded(event.response));
    } else {
      emit(ChatResponseReceived(event.response));
    }
  }

  void _onAbortRequest(AbortRequestEvent event, Emitter<ChatState> emit) {
    _getChatResponseUsecase.abortRequest();
    _chatSubscription?.cancel();
    emit(ChatAborted());
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_ollama_integration/features/chat_room/models/message_model.dart';

import '../../clients/locator_injector.dart';
import '../../services/secure_storage.dart';
import 'bloc/chat_bloc.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  // final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final List<MessageModel> _chatHistory = [];
  final ScrollController _scrollController = ScrollController();
  String _currentAiResponse = '';

  bool _isStreamMode = true;

  String? userName = '';
  final storageService = locator<SecureStorageImpl>();

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  void _loadSetting() async {
    userName = await storageService.readUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat'), actions: [
        Row(
          children: [
            const Text('Stream Mode'),
            Switch(
              value: _isStreamMode,
              onChanged: (value) {
                setState(() {
                  _isStreamMode = value;
                });
              },
            ),
          ],
        ),
      ]),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatResponseReceived && _isStreamMode) {
            setState(() {
              _currentAiResponse += state.response.response!;
              _scrollToBottom();
            });
          } else if (state is ChatLoaded) {
            setState(() {
              if (_isStreamMode) {
                _chatHistory.add(MessageModel(
                  sender: MessageRole.ai,
                  message: _currentAiResponse,
                  time: DateTime.now(),
                ));
                _currentAiResponse = '';
              } else {
                _chatHistory.add(MessageModel(
                  sender: MessageRole.ai,
                  message: state.response.response.toString(),
                  time: DateTime.now(),
                ));
              }
              _scrollToBottom();
            });
          } else if (state is ChatAborted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chat request aborted')),
            );
            setState(() {
              if (_currentAiResponse.isNotEmpty) {
                _chatHistory.add(MessageModel(
                  sender: MessageRole.ai,
                  message: '$_currentAiResponse [Aborted]',
                  time: DateTime.now(),
                ));
                _currentAiResponse = '';
                _scrollToBottom();
              }
            });
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _chatHistory.length +
                      (_currentAiResponse.isNotEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _chatHistory.length) {
                      final message = _chatHistory[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                message.sender == MessageRole.user
                                    ? userName?.isEmpty ?? true
                                        ? 'User'
                                        : userName!
                                    : 'AI',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: message.sender == MessageRole.user
                                      ? Colors.blue
                                      : Colors.amber.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              MarkdownBody(
                                data: _chatHistory[index].message,
                                selectable: true,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'AI',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              MarkdownBody(
                                data: _currentAiResponse,
                                selectable: true,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              if (state is ChatLoading) const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (value) {
                          if (_controller.text.isNotEmpty) {
                            context.read<ChatBloc>().add(SendMessageEvent(
                                _controller.text,
                                streamMode: _isStreamMode));
                            setState(() {
                              _chatHistory.add(MessageModel(
                                sender: MessageRole.user,
                                message: _controller.text,
                                time: DateTime.now(),
                              ));
                              _controller.clear();
                              _scrollToBottom();
                            });
                          }
                        },
                        decoration:
                            const InputDecoration(hintText: 'Type a message'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          context.read<ChatBloc>().add(SendMessageEvent(
                              _controller.text,
                              streamMode: _isStreamMode));
                          setState(() {
                            _chatHistory.add(MessageModel(
                              sender: MessageRole.user,
                              message: _controller.text,
                              time: DateTime.now(),
                            ));
                            _controller.clear();
                            _scrollToBottom();
                          });
                        }
                      },
                    ),
                    if (state is ChatLoading)
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () {
                          context.read<ChatBloc>().add(AbortRequestEvent());
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
          // return Column(
          //   children: [
          //     Expanded(
          //       child: ListView.builder(
          //         itemCount: _messages.length,
          //         itemBuilder: (context, index) {
          //           return Card(
          //             margin: const EdgeInsets.symmetric(
          //                 vertical: 8, horizontal: 16),
          //             child: Padding(
          //               padding: const EdgeInsets.all(16),
          //               child: MarkdownBody(
          //                 data: _messages[index],
          //                 selectable: true,
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //     if (state is ChatLoading) const CircularProgressIndicator(),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: TextField(
          //               controller: _controller,
          //               decoration:
          //                   const InputDecoration(hintText: 'Type a message'),
          //             ),
          //           ),
          //           IconButton(
          //             icon: const Icon(Icons.send),
          //             onPressed: () {
          //               if (_controller.text.isNotEmpty) {
          //                 context
          //                     .read<ChatBloc>()
          //                     .add(SendMessageEvent(_controller.text));
          //                 setState(() {
          //                   _messages.add("You: ${_controller.text} \n");
          //                   _messages.add("AI:\n");
          //                   _controller.clear();
          //                 });
          //               }
          //             },
          //           ),
          //           if (state is ChatLoading)
          //             IconButton(
          //               icon: const Icon(Icons.stop),
          //               onPressed: () {
          //                 context.read<ChatBloc>().add(AbortRequestEvent());
          //               },
          //             ),
          //         ],
          //       ),
          //     ),
          //   ],
          // );
        },
      ),
    );
  }
}

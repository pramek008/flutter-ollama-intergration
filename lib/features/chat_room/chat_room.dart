import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'bloc/chat_bloc.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatResponseReceived) {
            setState(() {
              if (_messages.isNotEmpty) {
                _messages[_messages.length - 1] += state.response.response!;
              } else {
                _messages.add(state.response.response!);
              }
            });
          } else if (state is ChatAborted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chat request aborted')),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: MarkdownBody(
                          data: _messages[index],
                          selectable: true,
                        ),
                      ),
                    );
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
                        decoration:
                            const InputDecoration(hintText: 'Type a message'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          context
                              .read<ChatBloc>()
                              .add(SendMessageEvent(_controller.text));
                          setState(() {
                            _messages.add("You: ${_controller.text} \n");
                            _messages.add("AI:\n");
                            _controller.clear();
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
        },
      ),
    );
  }
}

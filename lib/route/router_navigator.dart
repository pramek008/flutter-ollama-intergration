import 'package:flutter/material.dart';
import 'package:flutter_ollama_integration/features/chat_room/chat_room_screen.dart';
import 'package:flutter_ollama_integration/features/choose_models/setting_model_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: GlobalKey<NavigatorState>(),
  errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  )),
  routes: [
    GoRoute(
      path: '/',
      name: 'setting-model',
      builder: (BuildContext context, GoRouterState state) =>
          SettingModelScreen(),
    ),
    GoRoute(
      path: '/chat-room',
      name: 'chat-room',
      builder: (context, state) => ChatRoomScreen(),
    ),
  ],
);

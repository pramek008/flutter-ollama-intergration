import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

abstract class AppServices {
  GlobalKey<NavigatorState>? navigatorStateKey;

  NavigatorState? get navigatorState;

  Logger get logger;
}

class AppServicesImpl implements AppServices {
  NavigatorState? _navigatorState;

  @override
  NavigatorState? get navigatorState {
    _navigatorState ??= navigatorStateKey!.currentState;
    return _navigatorState;
  }

  @override
  GlobalKey<NavigatorState>? navigatorStateKey = GlobalKey<NavigatorState>();

  @override
  Logger get logger => Logger();
}

import 'package:flutter/services.dart';

import '../components/cubit/game_cubit.dart';

mixin PlayerKeyboardMovement {
  final _rightKeys = [LogicalKeyboardKey.arrowRight, LogicalKeyboardKey.keyD];
  final _leftKeys = [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.keyA];
  final _jumpKeys = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.space];

  late Set<LogicalKeyboardKey> _keysPressed;

  void onKeyPressed(Set<LogicalKeyboardKey> keysPressed, GameCubit cubit) {
    _keysPressed = keysPressed;

    final isRightKeyPressed = _isKeyAnyPressed(_rightKeys);
    final isLeftKeyPressed = _isKeyAnyPressed(_leftKeys);
    final isJumpKeyPressed = _isKeyAnyPressed(_jumpKeys);

    double xDirection = 0.0;

    if (isLeftKeyPressed) {
      xDirection = -1.0;
    } else if (isRightKeyPressed) {
      xDirection = 1.0;
    }

    cubit.movePlayer(xDirection: xDirection);
  }

  bool _isKeyAnyPressed(List<LogicalKeyboardKey> keys) {
    for (var key in keys) {
      final match = _keysPressed.contains(key);

      if (match) {
        return true;
      }
    }

    return false;
  }
}

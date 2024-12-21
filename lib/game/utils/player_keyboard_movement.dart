import 'package:flutter/services.dart';

import '../cubit/game_cubit.dart';

mixin PlayerKeyboardMovement {
  final _rightKeys = [LogicalKeyboardKey.arrowRight, LogicalKeyboardKey.keyD];

  final _leftKeys = [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.keyA];

  final _jumpKeys = [
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.space,
    LogicalKeyboardKey.keyW,
  ];

  late Set<LogicalKeyboardKey> _keysPressed;

  bool onKeyPressedHandler(
    Set<LogicalKeyboardKey> keysPressed,
    GameCubit cubit,
  ) {
    _keysPressed = keysPressed;

    final isRightKeyPressed = _isKeyAnyPressed(_rightKeys);
    final isLeftKeyPressed = _isKeyAnyPressed(_leftKeys);
    final isJumpKeyPressed = _isKeyAnyPressed(_jumpKeys);

    bool playerJumped = false;
    double direction = 0.0;

    if (isLeftKeyPressed) {
      direction = -1.0;
    }

    if (isRightKeyPressed) {
      direction = 1.0;
    }

    if (isJumpKeyPressed) {
      playerJumped = true;
    }

    cubit.movePlayer(direction: direction, playerJumped: playerJumped);

    return isLeftKeyPressed || isRightKeyPressed || isJumpKeyPressed;
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

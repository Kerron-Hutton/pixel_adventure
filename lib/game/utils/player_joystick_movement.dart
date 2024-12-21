import 'package:flame/components.dart';

import '../cubit/game_cubit.dart';

mixin PlayerJoystickMovement {
  void onJoystickDrag(JoystickComponent joystick, GameCubit cubit) {
    switch (joystick.direction) {
      case JoystickDirection.downLeft:
      case JoystickDirection.upLeft:
      case JoystickDirection.left:
        cubit.movePlayer(direction: -1);
        break;
      case JoystickDirection.downRight:
      case JoystickDirection.upRight:
      case JoystickDirection.right:
        cubit.movePlayer(direction: 1);
        break;
      default:
        cubit.movePlayer(direction: 0);
        break;
    }
  }
}

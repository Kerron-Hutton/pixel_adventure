import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'enums.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState());

  void movePlayer({double? xDirection}) {
    emit(state.copyWith(
      playerMovementX: xDirection ?? state.playerMovementX,
    ));
  }

  void changePlayerState(PlayerState playerState) {
    emit(state.copyWith(
      playerState: playerState,
    ));
  }

  void setShowJoystick(bool shouldShow) {
    emit(state.copyWith(
      showJoyStick: shouldShow,
    ));
  }
}

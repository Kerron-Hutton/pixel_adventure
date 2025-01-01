import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums/player_state.dart';
import '../components/collision_block.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  void movePlayer({double? direction, bool? playerJumped}) {
    emit(state.copyWith(
      playerDirection: direction ?? state.playerDirection,
      playerJumped: playerJumped ?? state.playerJumped,
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

  void setCollisionBlocks(List<CollisionBlock> blocks) {
    emit(state.copyWith(
      collisionBlocks: blocks,
    ));
  }
}

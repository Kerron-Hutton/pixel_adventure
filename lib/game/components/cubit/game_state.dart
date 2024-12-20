part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.playerState = PlayerState.idle,
    this.showJoyStick = false,
    this.playerMovementX = 0,
  });

  final double playerMovementX;
  final PlayerState playerState;
  final bool showJoyStick;

  @override
  List<Object?> get props => [playerMovementX, playerState, showJoyStick];

  GameState copyWith({
    PlayerState? playerState,
    double? playerMovementX,
    bool? showJoyStick,
  }) {
    return GameState(
      playerMovementX: playerMovementX ?? this.playerMovementX,
      showJoyStick: showJoyStick ?? this.showJoyStick,
      playerState: playerState ?? this.playerState,
    );
  }
}

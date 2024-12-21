part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.playerState = PlayerState.idle,
    this.collisionBlocks = const [],
    this.showJoyStick = false,
    this.playerJumped = false,
    this.playerDirection = 0,
  });

  final List<CollisionBlock> collisionBlocks;
  final PlayerState playerState;
  final double playerDirection;
  final bool playerJumped;
  final bool showJoyStick;

  @override
  List<Object?> get props => [
        collisionBlocks,
        playerDirection,
        playerJumped,
        showJoyStick,
        playerState,
      ];

  GameState copyWith({
    List<CollisionBlock>? collisionBlocks,
    PlayerState? playerState,
    double? playerDirection,
    bool? playerJumped,
    bool? showJoyStick,
  }) {
    return GameState(
      collisionBlocks: collisionBlocks ?? this.collisionBlocks,
      playerDirection: playerDirection ?? this.playerDirection,
      playerJumped: playerJumped ?? this.playerJumped,
      showJoyStick: showJoyStick ?? this.showJoyStick,
      playerState: playerState ?? this.playerState,
    );
  }
}

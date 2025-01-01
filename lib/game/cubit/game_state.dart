part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.playerState = PlayerState.idle,
    this.collisionBlocks = const [],
    this.isLevelCompleted = false,
    this.showJoyStick = false,
    this.playerJumped = false,
    this.playerDirection = 0,
  });

  final List<CollisionBlock> collisionBlocks;
  final PlayerState playerState;
  final double playerDirection;
  final bool playerJumped;
  final bool showJoyStick;

  final bool isLevelCompleted;

  @override
  List<Object?> get props => [
        collisionBlocks,
        playerDirection,
        isLevelCompleted,
        playerJumped,
        showJoyStick,
        playerState,
      ];

  GameState copyWith({
    List<CollisionBlock>? collisionBlocks,
    PlayerState? playerState,
    double? playerDirection,
    bool? isLevelCompleted,
    bool? playerJumped,
    bool? showJoyStick,
  }) {
    return GameState(
      isLevelCompleted: isLevelCompleted ?? this.isLevelCompleted,
      collisionBlocks: collisionBlocks ?? this.collisionBlocks,
      playerDirection: playerDirection ?? this.playerDirection,
      playerJumped: playerJumped ?? this.playerJumped,
      showJoyStick: showJoyStick ?? this.showJoyStick,
      playerState: playerState ?? this.playerState,
    );
  }
}

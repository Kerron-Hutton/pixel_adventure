import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../../core/constants/asset_path.dart';
import '../../core/constants/game_constants.dart';
import '../../core/enums/player_state.dart';
import '../cubit/game_cubit.dart';
import '../pixel_adventure.dart';
import 'player.dart';

enum CheckpointFlagState { flagOut, noFlag, idle }

class CheckpointFlag extends SpriteAnimationGroupComponent
    with
        FlameBlocReader<GameCubit, GameState>,
        HasGameRef<PixelAdventure>,
        CollisionCallbacks {
  CheckpointFlag({required super.position, required super.size});

  late SpriteAnimation _flagIdleAnimation;
  late SpriteAnimation _noFlagAnimation;
  late SpriteAnimation _flagOutAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(RectangleHitbox(
      collisionType: CollisionType.passive,
      position: Vector2(21, 17),
      size: Vector2(6, 48),
    ));

    _loadFlagAnimations();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      current = CheckpointFlagState.flagOut;

      bloc.changePlayerState(PlayerState.reachFinishLine);

      animationTickers?[CheckpointFlagState.flagOut]?.completed.whenComplete(
        () {
          current = CheckpointFlagState.idle;
        },
      );
    }
  }

  void _loadFlagAnimations() {
    _flagOutAnimation = _createSpriteAnimation(
      imgSrc: AssetPath.checkpointFlagOutImg,
      frames: 26,
    )..loop = false;

    _flagIdleAnimation = _createSpriteAnimation(
      imgSrc: AssetPath.checkpointFlagIdleImg,
      frames: 10,
    );

    _noFlagAnimation = _createSpriteAnimation(
      imgSrc: AssetPath.checkpointNoFlagImg,
      frames: 1,
    );

    animations = {
      CheckpointFlagState.flagOut: _flagOutAnimation,
      CheckpointFlagState.noFlag: _noFlagAnimation,
      CheckpointFlagState.idle: _flagIdleAnimation,
    };

    current = CheckpointFlagState.noFlag;
  }

  SpriteAnimation _createSpriteAnimation({
    required String imgSrc,
    required int frames,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(imgSrc),
      SpriteAnimationData.sequenced(
        stepTime: GameConstants.animationStepTime,
        textureSize: Vector2.all(64),
        amount: frames,
      ),
    );
  }
}

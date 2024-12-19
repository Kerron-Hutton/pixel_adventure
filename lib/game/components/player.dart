import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/game/pixel_adventure.dart';

import '../../core/constants/asset_path.dart';
import '../../core/constants/game_constants.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  Player({required super.position});

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _loadPlayerAnimations();
  }

  void _loadPlayerAnimations() {
    _idleAnimation = _createSpriteAnimation(AssetPath.maskDudeIdleImg);
    _runAnimation = _createSpriteAnimation(AssetPath.maskDudeRunImg);

    animations = {
      PlayerState.running: _runAnimation,
      PlayerState.idle: _idleAnimation,
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _createSpriteAnimation(String imgSrc) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(imgSrc),
      SpriteAnimationData.sequenced(
        stepTime: GameConstants.characterStepTime,
        textureSize: Vector2.all(32),
        amount: 11,
      ),
    );
  }
}

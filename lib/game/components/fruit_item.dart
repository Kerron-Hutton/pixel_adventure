import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../../core/constants/asset_path.dart';
import '../pixel_adventure.dart';

import '../../core/constants/game_constants.dart';
import 'player.dart';

enum FruitState { collected, idle }

class FruitItem extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  FruitItem({required super.position, required this.fruit})
      : super(size: Vector2.all(32));

  late SpriteAnimation _collectedAnimation;
  late SpriteAnimation _fruitAnimation;

  final String fruit;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final hitboxSize = size * 0.5;

    add(RectangleHitbox(
      size: hitboxSize,
      anchor: Anchor.topLeft,
      position: Vector2(
        (size.x - hitboxSize.x) / 2,
        (size.y - hitboxSize.y) / 2,
      ),
    ));

    _collectedAnimation = _getSpriteAnimation(frames: 6, img: 'collected.png');
    _fruitAnimation = _getSpriteAnimation(img: '$fruit.png');

    animations = {
      FruitState.collected: _collectedAnimation,
      FruitState.idle: _fruitAnimation,
    };

    current = FruitState.idle;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Player) {
      current = FruitState.collected;

      Future.delayed(
        const Duration(milliseconds: 400),
        () => removeFromParent(),
      );
    }
  }

  SpriteAnimation _getSpriteAnimation({
    required String img,
    int frames = 17,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('${AssetPath.fruitItemsAssetPath}/$img'),
      SpriteAnimationData.sequenced(
        stepTime: GameConstants.animationStepTime,
        textureSize: Vector2.all(32),
        amount: frames,
      ),
    );
  }
}

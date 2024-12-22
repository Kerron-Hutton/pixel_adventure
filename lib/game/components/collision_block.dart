import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/core/constants/game_constants.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({
    required this.collisionClass,
    required super.position,
    required super.size,
  });

  final String collisionClass;

  bool get isPlatform => collisionClass == GameConstants.platformObjectClass;

  bool get isTopBoundary =>
      collisionClass == GameConstants.topBoundaryObjectClass;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(RectangleHitbox(
      collisionType: CollisionType.passive,
      position: Vector2.zero(),
      anchor: Anchor.topLeft,
      size: size,
    ));
  }
}

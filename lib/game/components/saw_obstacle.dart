import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../../core/constants/asset_path.dart';
import '../cubit/game_cubit.dart';
import '../pixel_adventure.dart';

class SawObstacle extends SpriteAnimationComponent
    with
        FlameBlocReader<GameCubit, GameState>,
        HasGameRef<PixelAdventure>,
        CollisionCallbacks {
  SawObstacle({
    required this.horizontalPosTileRange,
    required this.horizontalNegTileRange,
    required this.verticalPosTileRange,
    required this.verticalNegTileRange,
    required this.isVerticalOrientation,
    required this.movementDirection,
    required this.hasChains,
    required super.priority,
    required super.position,
    required super.size,
  });

  static const double movementSpeed = 60;

  final double horizontalPosTileRange, horizontalNegTileRange;

  final double verticalPosTileRange, verticalNegTileRange;

  final bool isVerticalOrientation, hasChains;

  double movementDirection;

  late double horizontalPosRange, horizontalNegRange;
  late double verticalPosRange, verticalNegRange;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(CircleHitbox(collisionType: CollisionType.passive));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(AssetPath.sawOnImg),
      SpriteAnimationData.sequenced(
        textureSize: Vector2.all(38),
        stepTime: 0.03,
        amount: 8,
      ),
    );

    _calculateMovementRanges();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _handleSawMovement(dt);
  }

  void _calculateMovementRanges() {
    final tileSize = 16.0;

    horizontalPosRange = position.x + (tileSize * horizontalPosTileRange);
    horizontalNegRange = position.x - (tileSize * horizontalNegTileRange);

    verticalPosRange = position.y + (tileSize * verticalPosTileRange);
    verticalNegRange = position.y - (tileSize * verticalNegTileRange);
  }

  void _handleSawMovement(double delta) {
    var posRange = verticalPosRange;
    var negRange = verticalNegRange;
    var positionXorY = position.y;

    if (!isVerticalOrientation) {
      posRange = horizontalPosRange;
      negRange = horizontalNegRange;
      positionXorY = position.x;
    }

    if (positionXorY < negRange || positionXorY > posRange) {
      movementDirection *= -1;
    }

    final movementAmount = movementDirection * movementSpeed * delta;

    if (isVerticalOrientation) {
      position.y += movementAmount;
      return;
    }

    position.x += movementAmount;
  }
}

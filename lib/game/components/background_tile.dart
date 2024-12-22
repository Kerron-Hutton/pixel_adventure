import 'dart:async';

import 'package:flame/components.dart';
import '../../core/constants/game_constants.dart';
import '../../core/constants/asset_path.dart';
import '../pixel_adventure.dart';

// added offset to tiles to cause a little overlap
const _tileOffset = 0.6;

class BackgroundTile extends SpriteComponent with HasGameRef<PixelAdventure> {
  BackgroundTile({required super.position, required this.tileName})
      : super(
          priority: -1,
          anchor: Anchor.topLeft,
          size: Vector2.all(
            GameConstants.backgroundTileImageSize.toDouble() + _tileOffset,
          ),
        );

  final String tileName;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = Sprite(
      game.images.fromCache(
        '${AssetPath.backgroundAssetPath}/$tileName.png',
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += GameConstants.backgroundYScrollSpeed;

    final tileSize = GameConstants.backgroundTileImageSize.toDouble();
    final scrollHeight = (game.size.y / tileSize).floor();

    if (position.y > scrollHeight * tileSize) {
      position.y = -(tileSize);
    }
  }
}

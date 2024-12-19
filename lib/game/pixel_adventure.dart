import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/core/constants/game_constants.dart';

import '../core/constants/asset_path.dart';
import 'components/game_level.dart';

class PixelAdventure extends FlameGame<GameLevel> {
  PixelAdventure()
      : super(
          world: GameLevel(levelName: AssetPath.levelOneTiles),
          camera: CameraComponent.withFixedResolution(
            height: GameConstants.gameHeight,
            width: GameConstants.gameWidth,
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    /**
     * Load all images into cache.
     */
    await images.loadAllImages();
  }
}

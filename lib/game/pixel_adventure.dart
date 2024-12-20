import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/constants/asset_path.dart';
import '../core/constants/game_constants.dart';
import 'components/cubit/game_cubit.dart';
import 'components/game_level.dart';
import 'utils/player_joystick_movement.dart';

class PixelAdventure extends FlameGame<GameLevel>
    with HasKeyboardHandlerComponents, DragCallbacks, PlayerJoystickMovement {
  PixelAdventure(this.cubit)
      : super(
          world: GameLevel(levelName: AssetPath.levelOneTiles),
          camera: CameraComponent.withFixedResolution(
            height: GameConstants.gameHeight,
            width: GameConstants.gameWidth,
          ),
        );

  final GameCubit cubit;

  JoystickComponent? _joystick;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    /**
     * Load all images into cache.
     */
    await images.loadAllImages();

    if (cubit.state.showJoyStick) {
      add(
        _joystick = JoystickComponent(
          background: _createSpriteComponent(AssetPath.hudJoystick),
          knob: _createSpriteComponent(AssetPath.hudJoystickKnob),
          margin: const EdgeInsets.only(bottom: 32, left: 32),
          priority: 99,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_joystick != null) {
      onJoystickDrag(_joystick!, cubit);
    }
  }

  SpriteComponent _createSpriteComponent(String imgSrc) {
    return SpriteComponent(
      sprite: Sprite(
        images.fromCache(imgSrc),
      ),
    );
  }
}

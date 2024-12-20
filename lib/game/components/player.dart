import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';

import '../../core/constants/asset_path.dart';
import '../../core/constants/game_constants.dart';
import '../pixel_adventure.dart';
import '../utils/player_keyboard_movement.dart';
import 'cubit/game_cubit.dart';
import 'cubit/enums.dart';

class Player extends SpriteAnimationGroupComponent
    with
        HasGameRef<PixelAdventure>,
        KeyboardHandler,
        FlameBlocReader<GameCubit, GameState>,
        PlayerKeyboardMovement {
  Player({required super.position});

  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;

  var _isPlayerFacingRight = true;
  final _velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _loadPlayerAnimations();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updatePlayerMovement(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    onKeyPressed(keysPressed, bloc);
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadPlayerAnimations() {
    _idleAnimation = _createSpriteAnimation(AssetPath.maskDudeIdleImg);
    _runAnimation = _createSpriteAnimation(AssetPath.maskDudeRunImg);
    _jumpAnimation = _createSpriteAnimation(AssetPath.maskDudeJumpImg);

    animations = {
      PlayerState.running: _runAnimation,
      PlayerState.jump: _jumpAnimation,
      PlayerState.idle: _idleAnimation,
    };

    current = bloc.state.playerState;
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

  void _updatePlayerMovement(double dt) {
    /**
     * Flipping around the horizontal axis will affect the scale property
     * on the sprint component.
     * 
     * TODO: Do additional reading on the scale property
     */
    if ((_velocity.x > 0 && scale.x < 0) || _velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    }

    if (_velocity.x != 0) {
      bloc.changePlayerState(PlayerState.running);
    }

    _velocity.x = bloc.state.playerMovementX * GameConstants.playerMoveSpeed;

    current = bloc.state.playerState;
    position.x += _velocity.x * dt;
  }
}

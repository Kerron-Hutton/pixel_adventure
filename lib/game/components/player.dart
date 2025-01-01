import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';

import '../../core/constants/asset_path.dart';
import '../../core/constants/game_constants.dart';
import '../../core/enums/collision_direction.dart';
import '../../core/enums/player_state.dart';
import '../../core/utils/player_keyboard_movement.dart';
import '../cubit/game_cubit.dart';
import '../pixel_adventure.dart';
import 'collision_block.dart';

class Player extends SpriteAnimationGroupComponent
    with
        FlameBlocReader<GameCubit, GameState>,
        HasGameRef<PixelAdventure>,
        PlayerKeyboardMovement,
        CollisionCallbacks,
        KeyboardHandler {
  Player({required super.position}) : super(priority: 1);

  late final SpriteAnimation _disAppearingAnimation;
  late final SpriteAnimation _appearingAnimation;
  late final SpriteAnimation _doubleJumpAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _fallAnimation;
  late final SpriteAnimation _runAnimation;

  late RectangleHitbox _playerHitbox;

  final _velocity = Vector2.zero();
  bool _isOnGround = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _loadPlayerAnimations();

    add(
      _playerHitbox = RectangleHitbox(
        position: Vector2(10, 4),
        anchor: Anchor.topLeft,
        size: Vector2(14, 28),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    _playerReachedTheFinishLine();

    if (bloc.state.isLevelCompleted) {
      return;
    }

    _updatePlayerMovement(dt);

    // adding player gravity
    _velocity.y += GameConstants.playerGravity;

    // setting max speed a player can fall and max jump height
    _velocity.y = _velocity.y.clamp(
      -(GameConstants.playerJumpForce),
      GameConstants.playerTerminalVelocity,
    );

    position.y += _velocity.y * dt;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final handled = onKeyPressedHandler(keysPressed, bloc);

    if (handled) {
      return true;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is CollisionBlock) {
      _isOnGround = other.y.floor() == (position.y + size.y).floor();
      final collisionDirection = getCollisionDirection(other);

      if (collisionDirection.isHorizontal) {
        _handleHorizontalCollision(collisionDirection, other);
      } else if (collisionDirection.isVertical) {
        _handleVerticalCollision(collisionDirection, other);
      }
    }
  }

  void _handleHorizontalCollision(
    CollisionDirection direction,
    CollisionBlock block,
  ) {
    if (block.isPlatform) {
      return;
    }

    /**
     * offset of 2 is added to help prevent the player from going
     * on top of small platforms on collision.
     */
    final playerWidth = _playerHitbox.size.x + _playerHitbox.position.x + 2;

    if (direction.isRight) {
      _velocity.x = 0;
      position.x = block.x - playerWidth;
    } else if (direction.isLeft) {
      _velocity.x = 0;
      position.x = block.x + block.width + playerWidth;
    }
  }

  void _handleVerticalCollision(
    CollisionDirection direction,
    CollisionBlock block,
  ) {
    final playerHight = _playerHitbox.size.y + _playerHitbox.position.y;

    if (block.isPlatform) {
      if (direction.isBottom) {
        _velocity.y = 0;
        position.y = block.y - playerHight;
      }
    } else {
      if (!block.isTopBoundary) {
        if (direction.isBottom) {
          _velocity.y = 0;
          position.y = block.y - playerHight;
        } else if (direction.isTop) {
          _velocity.y = 0;
          position.y = block.y + block.height - playerHight;
        }
      } else {
        if (direction.isTop && _velocity.y < 0) {
          _velocity.y = 0;
          position.y = block.y;
        }
      }
    }
  }

  CollisionDirection getCollisionDirection(PositionComponent other) {
    // Compute the difference in positions
    final Vector2 difference =
        (position + size / 2) - (other.position + other.size / 2);

    // Calculate the absolute overlap on both axes
    final double overlapX =
        (size.x / 2 + other.size.x / 2) - difference.x.abs();

    final double overlapY =
        (size.y / 2 + other.size.y / 2) - difference.y.abs();

    if (overlapX < overlapY && bloc.state.playerDirection != 0) {
      // Collision is horizontal
      return difference.x > 0
          ? CollisionDirection.left
          : CollisionDirection.right;
    } else {
      // Collision is vertical
      return difference.y > 0
          ? CollisionDirection.top
          : CollisionDirection.bottom;
    }
  }

  void _loadPlayerAnimations() {
    _idleAnimation = _createSpriteAnimation(AssetPath.maskDudeIdleImg);

    _runAnimation = _createSpriteAnimation(
      AssetPath.maskDudeRunImg,
      frames: 12,
    );

    _jumpAnimation = _createSpriteAnimation(
      AssetPath.maskDudeJumpImg,
      frames: 1,
    );

    _doubleJumpAnimation = _createSpriteAnimation(
      AssetPath.maskDudeDoubleJumpImg,
      frames: 6,
    );

    _fallAnimation = _createSpriteAnimation(
      AssetPath.maskDudeFallImg,
      frames: 1,
    );

    _disAppearingAnimation = _createSpriteAnimation(
      AssetPath.characterDisappearingImg,
      textureSize: 96,
      frames: 7,
    );

    _appearingAnimation = _createSpriteAnimation(
      AssetPath.characterAppearingImg,
      textureSize: 96,
      frames: 7,
    )..loop = false;

    animations = {
      PlayerState.reachFinishLine: _disAppearingAnimation,
      PlayerState.doubleJump: _doubleJumpAnimation,
      PlayerState.falling: _fallAnimation,
      PlayerState.running: _runAnimation,
      PlayerState.jump: _jumpAnimation,
      PlayerState.idle: _idleAnimation,
    };

    current = bloc.state.playerState;
  }

  SpriteAnimation _createSpriteAnimation(
    String imgSrc, {
    double textureSize = 32,
    int frames = 11,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(imgSrc),
      SpriteAnimationData.sequenced(
        stepTime: GameConstants.animationStepTime,
        textureSize: Vector2.all(textureSize),
        amount: frames,
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    _handleSpriteFlipping();

    if (_isOnGround) {
      if (!bloc.state.playerState.isIdle && _velocity.x == 0) {
        bloc.changePlayerState(PlayerState.idle);
      } else if (_velocity.x != 0 && !bloc.state.playerState.isRunning) {
        bloc.changePlayerState(PlayerState.running);
      }
    }

    _handleJump(dt);
    _updateVelocityAndPosition(dt);
  }

  void _handleSpriteFlipping() {
    /**
     * Flipping around the horizontal axis will affect the scale property
     * on the sprint component.
     *
     * TODO: Do additional reading on the scale property
     */
    if ((_velocity.x > 0 && scale.x < 0) || (_velocity.x < 0 && scale.x > 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void _handleJump(double dt) {
    if (!bloc.state.playerJumped) {
      return;
    }

    if (_velocity.y > 0) {
      if (bloc.state.playerJumped) {
        bloc.changePlayerState(PlayerState.doubleJump);
      } else {
        bloc.changePlayerState(PlayerState.falling);
      }
    } else if (_velocity.y < 0) {
      bloc.changePlayerState(PlayerState.jump);
    }

    final jumpForce = _isOnGround
        ? GameConstants.playerJumpForce
        : GameConstants.playerJumpForce / 2;

    _velocity.y = -(jumpForce);
    position.y += _velocity.y * dt;

    bloc.movePlayer(playerJumped: false);

    _isOnGround = false;
  }

  void _updateVelocityAndPosition(double dt) {
    _velocity.x = bloc.state.playerDirection * GameConstants.playerMoveSpeed;

    current = bloc.state.playerState;
    position.x += _velocity.x * dt;
  }

  void _playerReachedTheFinishLine() {
    final reachedFinishLine = bloc.state.playerState.reachedFinishLine;

    if (!reachedFinishLine || bloc.state.isLevelCompleted) {
      return;
    }

    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.reachFinishLine;
    bloc.levelCompleted();
  }
}

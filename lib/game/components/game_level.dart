import 'dart:async';

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/components.dart';
import 'package:logger/logger.dart';

import '../../core/constants/asset_path.dart';
import '../../core/constants/game_constants.dart';
import '../cubit/game_cubit.dart';
import 'collision_block.dart';
import 'player.dart';

class GameLevel extends Component with FlameBlocReader<GameCubit, GameState> {
  GameLevel({required this.levelName});

  late final TiledComponent _level;

  final _logger = Logger();
  final String levelName;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _level = await TiledComponent.load(
      AssetPath.levelOneTiles,
      Vector2.all(16),
    );

    final player = _spawnPlayerInLevel();

    if (player == null) {
      throw Exception(
        'Error occurred while spawning player into the game world',
      );
    }

    final collisionBlocks = _getCollisionBlocksFromMap();

    bloc.setCollisionBlocks(collisionBlocks);

    addAll([_level, player, ...collisionBlocks]);
  }

  Player? _spawnPlayerInLevel() {
    final spawnPointLayer = _level.tileMap.getLayer<ObjectGroup>(
      GameConstants.spawnPointLayerName,
    );

    if (spawnPointLayer == null) {
      _logger.e('Spawn point layer cannot be empty.');
      return null;
    }

    for (var spawn in spawnPointLayer.objects) {
      switch (spawn.class_) {
        case GameConstants.spawnPointObjectClass:
          return Player(position: Vector2(spawn.x, spawn.y));
        default:
          _logger.w('Spawn point class "${spawn.class_}" not supported.');
          break;
      }
    }

    return null;
  }

  List<CollisionBlock> _getCollisionBlocksFromMap() {
    final collisionsLayer = _level.tileMap.getLayer<ObjectGroup>(
      GameConstants.collisionsLayerName,
    );

    final List<CollisionBlock> collisionBlocks = [];

    if (collisionsLayer == null) {
      _logger.e('Spawn point layer cannot be empty.');
      return [];
    }

    for (var collision in collisionsLayer.objects) {
      collisionBlocks.add(
        CollisionBlock(
          size: Vector2(collision.width, collision.height),
          position: Vector2(collision.x, collision.y),
          collisionClass: collision.class_,
        ),
      );
    }

    return collisionBlocks;
  }
}

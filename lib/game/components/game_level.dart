import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:logger/logger.dart';

import '../../core/constants/asset_path.dart';
import '../../core/constants/game_constants.dart';
import '../cubit/game_cubit.dart';
import '../pixel_adventure.dart';
import 'background_tile.dart';
import 'checkpoint_flag.dart';
import 'collision_block.dart';
import 'fruit_item.dart';
import 'player.dart';

class GameLevel extends Component
    with FlameBlocReader<GameCubit, GameState>, HasGameRef<PixelAdventure> {
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
    _scrollingBackgrounds();
    _spawnObjects();
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
      if (spawn.class_ == GameConstants.spawnPlayerObjectClass) {
        return Player(position: Vector2(spawn.x, spawn.y));
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

  void _scrollingBackgrounds() {
    final backgroundLayer = _level.tileMap.getLayer(
      GameConstants.levelBackgroundLayerName,
    );

    if (backgroundLayer == null) {
      return;
    }

    final backgroundColor = backgroundLayer.properties.getValue(
      GameConstants.backgroundLayerColorProp,
    );

    final tileImgSize = GameConstants.backgroundTileImageSize;

    /**
     * adding +2 to the number of tiles will remove a gap found when
     * while doing endless scrolling.
     */
    final numOfTilesInYDirection = (game.size.y / tileImgSize).floor() + 2;
    final numOfTilesInXDirection = (game.size.x / tileImgSize).floor();

    for (double y = 0; y < numOfTilesInYDirection; y++) {
      for (double x = 0; x < numOfTilesInXDirection; x++) {
        add(
          BackgroundTile(
            /**
             * subtracting tileSize will allow us to have some buffer
             * from the edge of the screen before scrolling.
             */
            position: Vector2(x * tileImgSize, y * tileImgSize - tileImgSize),
            tileName: backgroundColor ?? 'gray',
          ),
        );
      }
    }
  }

  void _spawnObjects() {
    final spawnPointLayer = _level.tileMap.getLayer<ObjectGroup>(
      GameConstants.spawnPointLayerName,
    );

    if (spawnPointLayer == null) {
      return;
    }

    for (final spawn in spawnPointLayer.objects) {
      switch (spawn.class_) {
        case GameConstants.spawnFruitObjectClass:
          add(FruitItem(
            position: Vector2(spawn.x, spawn.y),
            fruit: spawn.name,
          ));
          break;
        case GameConstants.spawnCheckpointObjectClass:
          add(CheckpointFlag(
            size: Vector2(spawn.width, spawn.height),
            position: Vector2(spawn.x, spawn.y),
          ));
          break;
      }
    }
  }
}

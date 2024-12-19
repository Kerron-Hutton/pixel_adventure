import 'dart:async';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/components.dart';
import 'package:logger/logger.dart';

import '../../core/constants/asset_path.dart';
import '../../core/constants/game_constants.dart';
import 'player.dart';

class GameLevel extends World {
  GameLevel({required this.levelName});

  late final TiledComponent _level;

  final _logger = Logger();
  final String levelName;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _level = await TiledComponent.load(
      AssetPath.levelOneTiles,
      Vector2.all(16),
    );

    _addSpawnPoints();
    add(_level);
  }

  void _addSpawnPoints() {
    final spawnPointLayer = _level.tileMap.getLayer<ObjectGroup>(
      GameConstants.spawnPointLayerName,
    );

    if (spawnPointLayer == null) {
      _logger.e('Spawn point layer cannot be empty.');
      return;
    }

    for (var spawn in spawnPointLayer.objects) {
      switch (spawn.class_) {
        case GameConstants.spawnPointObjectClass:
          add(Player(position: Vector2(spawn.x, spawn.y)));
          break;
        default:
      }
    }
  }
}

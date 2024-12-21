import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pixel_adventure/core/constants/asset_path.dart';
import 'package:pixel_adventure/game/components/game_level.dart';
import 'package:pixel_adventure/game/pixel_adventure.dart';

import '../cubit/game_cubit.dart';

class GameWorld extends World with HasGameRef<PixelAdventure> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      FlameBlocProvider<GameCubit, GameState>(
        create: () => game.cubit,
        children: [
          GameLevel(levelName: AssetPath.levelOneTiles),
        ],
      ),
    );
  }
}

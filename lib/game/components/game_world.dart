import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../../core/constants/asset_path.dart';
import '../cubit/game_cubit.dart';
import '../pixel_adventure.dart';
import 'game_level.dart';

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

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/core/constants/game_colors.dart';

import 'game/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();

  runApp(GameWidget(
    game: PixelAdventure(),
    backgroundBuilder: (context) {
      return Container(
        color: GameColors.background,
      );
    },
  ));
}

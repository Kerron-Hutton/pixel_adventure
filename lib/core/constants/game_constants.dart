abstract class GameConstants {
  static const gameHeight = 360.0;
  static const gameWidth = 640.0;

  static const backgroundTileImageSize = 64;
  static const backgroundYScrollSpeed = 0.4;

  /// All animations have a speed of 20 FPS or 50 MS
  static const animationStepTime = 1 / 20;

  /// Terminal velocity is the constant speed at which an object falls
  /// through a fluid (such as air or water). As an object falls, it
  /// experiences two main forces: gravity pulling it downward and
  /// drag (or resistance) from the fluid pushing it upward.
  static const playerTerminalVelocity = 400.0;

  static const playerMoveSpeed = 100.0;
  static const playerJumpForce = 280.0;
  static const playerGravity = 9.8;

  static const spawnCheckpointObjectClass = 'checkpoint';
  static const spawnPointLayerName = 'spawn_points';
  static const spawnPlayerObjectClass = 'player';
  static const spawnFruitObjectClass = 'fruit';

  static const topBoundaryObjectClass = 'top_boundary';
  static const collisionsLayerName = 'collisions';
  static const platformObjectClass = 'platform';

  static const levelBackgroundLayerName = 'background';
  static const backgroundLayerColorProp = 'background_color';
}

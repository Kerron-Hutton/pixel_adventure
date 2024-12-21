enum PlayerState {
  doubleJump,
  running,
  falling,
  idle,
  jump;

  bool get isIdle => this == PlayerState.idle;

  bool get isFalling => this == PlayerState.falling;

  bool get isRunning => this == PlayerState.running;

  bool get isJumping =>
      this == PlayerState.jump || this == PlayerState.doubleJump;
}

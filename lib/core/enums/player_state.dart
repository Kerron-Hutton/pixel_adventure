enum PlayerState {
  reachFinishLine,
  doubleJump,
  running,
  falling,
  idle,
  hit,
  jump;

  bool get isIdle => this == PlayerState.idle;

  bool get isFalling => this == PlayerState.falling;

  bool get isRunning => this == PlayerState.running;

  bool get reachedFinishLine => this == PlayerState.reachFinishLine;

  bool get isJumping =>
      this == PlayerState.jump || this == PlayerState.doubleJump;
}

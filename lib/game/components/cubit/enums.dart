enum PlayerState {
  idle,
  running,
  jump;

  bool get isIdle => this == PlayerState.idle;

  bool get isRunning => this == PlayerState.running;

  bool get isJumping => this == PlayerState.jump;
}

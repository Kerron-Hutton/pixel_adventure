enum CollisionDirection {
  top,
  bottom,
  left,
  right;

  bool get isHorizontal => [
        CollisionDirection.right,
        CollisionDirection.left,
      ].contains(this);

  bool get isVertical => [
        CollisionDirection.bottom,
        CollisionDirection.top,
      ].contains(this);

  bool get isTop => this == CollisionDirection.top;

  bool get isBottom => this == CollisionDirection.bottom;

  bool get isLeft => this == CollisionDirection.left;

  bool get isRight => this == CollisionDirection.right;
}

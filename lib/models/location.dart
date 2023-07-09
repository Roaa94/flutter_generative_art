class Location {
  const Location({
    this.x = 0.0,
    this.y = 0.0,
  });

  final double x;
  final double y;

  static const Location zero = Location();
  static const Location one = Location(x: 1.0, y: 1.0);
}

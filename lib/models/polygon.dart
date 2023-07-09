import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/location.dart';

class Polygon {
  const Polygon({
    this.topLeft = Offset.zero,
    this.topRight = Offset.zero,
    this.bottomRight = Offset.zero,
    this.bottomLeft = Offset.zero,
    this.topLeftOrigin = Offset.zero,
    this.topRightOrigin = Offset.zero,
    this.bottomRightOrigin = Offset.zero,
    this.bottomLeftOrigin = Offset.zero,
    this.color = Colors.white,
    this.location = const Location(),
    this.level = 0.0,
    this.image,
  });

  final Offset topLeft;
  final Offset topRight;
  final Offset bottomRight;
  final Offset bottomLeft;
  final Offset topLeftOrigin;
  final Offset topRightOrigin;
  final Offset bottomRightOrigin;
  final Offset bottomLeftOrigin;
  final Color color;
  final double level;
  final Location location;
  final ui.Image? image;

  bool get animationEnabled => true;

  // The entire animation is between 0 and 1, and we need to implement
  // 2 separate animations that have delays
  // The first is the delay between the painting of each polygon in a single polygon set
  // And the second is the delay between entire polygon sets starting to paint
  static const animationDurationFraction = 0.5;

  double get animationStart => location.x * level;

  double get animationEnd =>
      (animationStart + 0.2) >= 1.0 ? 1.0 : (animationStart + 0.2);

  Offset get center {
    double centerX =
        (topLeft.dx + topRight.dx + bottomRight.dx + bottomLeft.dx) / 4;
    double centerY =
        (topLeft.dy + topRight.dy + bottomRight.dy + bottomLeft.dy) / 4;
    return Offset(centerX, centerY);
  }

  List<Offset> get points => [
        topLeft,
        topRight,
        bottomRight,
        bottomLeft,
        topLeft,
      ];

  List<Offset> get originPoints => [
        topLeftOrigin,
        topRightOrigin,
        bottomRightOrigin,
        bottomLeftOrigin,
        topLeftOrigin,
      ];

  List<Offset> getLerpedPoints(double value) {
    return [
      Offset.lerp(topLeft, topLeftOrigin, value)!,
      Offset.lerp(topRight, topRightOrigin, value)!,
      Offset.lerp(bottomRight, bottomRightOrigin, value)!,
      Offset.lerp(bottomLeft, bottomLeftOrigin, value)!,
      Offset.lerp(topLeft, topLeftOrigin, value)!,
    ];
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/polygon.dart';
import 'package:flutter_generative_art/vera_molnar/utils.dart';

class DistortedPolygon extends StatelessWidget {
  const DistortedPolygon({
    super.key,
    this.maxCornersOffset = 20,
    this.strokeWidth = 2,
    this.minSquareSideFraction = 2,
    this.child,
    this.color = Colors.black,
  });

  final double maxCornersOffset;
  final double strokeWidth;
  final double minSquareSideFraction;
  final Widget? child;
  final Color color;

  static final Random random = Random();

  Polygon _createPolygon(context, maxSideLength) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Offset topLeft = Offset.zero;
    Offset topRight = topLeft + Offset(maxSideLength, 0);
    Offset bottomRight = topLeft + Offset(maxSideLength, maxSideLength);
    Offset bottomLeft = topLeft + Offset(0, maxSideLength);

    topLeft += randomOffsetFromRange(random, maxCornersOffset);
    topRight += randomOffsetFromRange(random, maxCornersOffset);
    bottomRight += randomOffsetFromRange(random, maxCornersOffset);
    bottomLeft += randomOffsetFromRange(random, maxCornersOffset);

    return Polygon(
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomPaint(
      painter: DistortedPolygonCustomPainter(
        polygon: _createPolygon(context, size.shortestSide * minSquareSideFraction),
        strokeWidth: strokeWidth,
      ),
      child: child,
    );
  }
}

class DistortedPolygonCustomPainter extends CustomPainter {
  DistortedPolygonCustomPainter({
    required this.polygon,
    this.strokeWidth = 2,
  });

  final Polygon polygon;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = polygon.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    
    canvas.save();
    canvas.translate(center.dx - polygon.center.dx, center.dy - polygon.center.dy);
    canvas.drawPoints(
      PointMode.polygon,
      polygon.points,
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

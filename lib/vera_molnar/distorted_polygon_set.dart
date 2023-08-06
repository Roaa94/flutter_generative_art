import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/vera_molnar/utils.dart';

class DistortedPolygonSet extends StatelessWidget {
  const DistortedPolygonSet({
    super.key,
    this.maxCornersOffset = 20,
    this.minRepetition = 20,
    this.strokeWidth = 2,
    this.child,
  });

  final double maxCornersOffset;
  final double strokeWidth;
  final int minRepetition;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.white,
        child: CustomPaint(
          painter: _DistortedPolygonSetCustomPainter(
            maxCornersOffset: maxCornersOffset,
            strokeWidth: strokeWidth,
            minRepetition: minRepetition,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DistortedPolygonSetCustomPainter extends CustomPainter {
  _DistortedPolygonSetCustomPainter({
    this.strokeWidth = 2,
    this.maxCornersOffset = 20,
    this.minRepetition = 20,
  });

  final double strokeWidth;
  final double maxCornersOffset;
  final int minRepetition;

  static final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);

    final side = size.shortestSide * 0.7;

    final repetition = random.nextInt(10) + minRepetition;

    for (int i = 0; i < repetition; i++) {
      Offset topLeft = Offset.zero;
      Offset topRight = topLeft + Offset(side, 0);
      Offset bottomRight = topLeft + Offset(side, side);
      Offset bottomLeft = topLeft + Offset(0, side);

      topLeft += randomOffsetFromRange(random, maxCornersOffset);
      topRight += randomOffsetFromRange(random, maxCornersOffset);
      bottomRight += randomOffsetFromRange(random, maxCornersOffset);
      bottomLeft += randomOffsetFromRange(random, maxCornersOffset);

      Offset polygonCenter = Offset(
        (topLeft.dx + topRight.dx + bottomRight.dx + bottomLeft.dx) / 4,
        (topLeft.dy + topRight.dy + bottomRight.dy + bottomLeft.dy) / 4,
      );

      canvas.save();
      canvas.translate(
        center.dx - polygonCenter.dx,
        center.dy - polygonCenter.dy,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [
          topLeft,
          topRight,
          bottomRight,
          bottomLeft,
          topLeft,
        ],
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

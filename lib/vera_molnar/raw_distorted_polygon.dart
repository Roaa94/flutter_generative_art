import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/polygon.dart';
import 'package:flutter_generative_art/vera_molnar/utils.dart';

class DistortedPolygon extends StatelessWidget {
  const DistortedPolygon({
    super.key,
    this.maxCornersOffset = 20,
    this.maxSideLength = 250,
    this.minRepetition = 5,
    this.maxRepetition = 5,
    this.strokeWidth = 2,
  });

  final double maxCornersOffset;
  final double maxSideLength;
  final double strokeWidth;
  final int minRepetition;
  final int maxRepetition;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: DistortedPolygonCustomPainter(
          strokeWidth: strokeWidth,
          maxSideLength: maxSideLength,
          maxCornersOffset: maxCornersOffset,
          minRepetition: minRepetition,
          maxRepetition: maxRepetition,
        ),
      ),
    );
  }
}

class DistortedPolygonCustomPainter extends CustomPainter {
  DistortedPolygonCustomPainter({
    this.strokeWidth = 2,
    this.maxSideLength = 200,
    this.maxCornersOffset = 20,
    this.minRepetition = 5,
    this.maxRepetition = 20,
  });

  final double strokeWidth;
  final double maxSideLength;
  final double maxCornersOffset;
  final int minRepetition;
  final int maxRepetition;

  static final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeWidth;

    Offset topLeft = Offset.zero;
    Offset topRight = topLeft + Offset(maxSideLength, 0);
    Offset bottomRight = topLeft + Offset(maxSideLength, maxSideLength);
    Offset bottomLeft = topLeft + Offset(0, maxSideLength);

    final canvasCenter = Offset(size.width / 2, size.height / 2);

    final polygonCenter = Offset(
      (topLeft.dx + topRight.dx + bottomRight.dx + bottomLeft.dx) / 4,
      (topLeft.dy + topRight.dy + bottomRight.dy + bottomLeft.dy) / 4,
    );

    // Paint Method
    canvas.save();
    canvas.translate(
      canvasCenter.dx - polygonCenter.dx,
      canvasCenter.dy - polygonCenter.dy,
    );
    for (int i = 0;
        i <
            random.nextInt(maxRepetition > minRepetition
                    ? maxRepetition - minRepetition
                    : maxRepetition + minRepetition) +
                minRepetition;
        i++) {
      topLeft += Offset(
        maxCornersOffset * 2 * (random.nextDouble() - 0.5),
        maxCornersOffset * 2 * (random.nextDouble() - 0.5),
      );
      topRight += Offset(
        maxCornersOffset * 2 * (random.nextDouble() - 0.5),
        maxCornersOffset * 2 * (random.nextDouble() - 0.5),
      );
      bottomRight += Offset(
        maxCornersOffset * 2 * (random.nextDouble() - 0.5),
        maxCornersOffset * 2 * (random.nextDouble() - 0.5),
      );
      bottomLeft += Offset(
        maxCornersOffset * 2 * (random.nextDouble() - 0.5),
        maxCornersOffset * 2 * (random.nextDouble() - 0.5),
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
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

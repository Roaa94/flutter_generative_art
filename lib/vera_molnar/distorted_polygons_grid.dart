import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class DistortedPolygonsGrid extends StatelessWidget {
  const DistortedPolygonsGrid({
    super.key,
    this.maxSideLength = 80,
    this.strokeWidth = 1,
    this.gap = 30,
    this.maxCornersOffset = 20,
    this.saturation = 0.7,
    this.lightness = 0.5,
    this.enableRepetition = true,
    this.enableColors = false,
    this.minRepetition = 10,
  });

  final double maxSideLength;
  final double strokeWidth;
  final double gap;
  final double maxCornersOffset;
  final double saturation;
  final double lightness;
  final bool enableRepetition;
  final bool enableColors;
  final int minRepetition;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomPaint(
            painter: RecursiveSquaresCustomPainter(
              maxSideLength: maxSideLength,
              strokeWidth: strokeWidth,
              gap: gap,
              maxCornersOffset: maxCornersOffset,
              saturation: saturation,
              lightness: lightness,
              enableRepetition: enableRepetition,
              enableColors: enableColors,
              minRepetition: minRepetition,
            ),
          ),
        ),
      ),
    );
  }
}

class RecursiveSquaresCustomPainter extends CustomPainter {
  RecursiveSquaresCustomPainter({
    this.maxSideLength = 80,
    this.strokeWidth = 2,
    this.gap = 10,
    this.maxCornersOffset = 20,
    this.enableRepetition = true,
    this.enableColors = false,
    this.saturation = 0.7,
    this.lightness = 0.5,
    this.minRepetition = 10,
  });

  final double maxSideLength;
  final double strokeWidth;
  final double gap;
  final double maxCornersOffset;
  final double saturation;
  final double lightness;
  final bool enableRepetition;
  final bool enableColors;
  final int minRepetition;

  static final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final xCount = ((size.width + gap) / (maxSideLength + gap)).floor();
    final yCount = ((size.height + gap) / (maxSideLength + gap)).floor();
    final contentSize = Size(
      (xCount * maxSideLength) + ((xCount - 1) * gap),
      (yCount * maxSideLength) + ((yCount - 1) * gap),
    );
    final offset = Offset(
      (size.width - contentSize.width) / 2,
      (size.height - contentSize.height) / 2,
    );

    final totalCount = xCount * yCount;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    for (int index = 0; index < totalCount; index++) {
      int i = index ~/ yCount;
      int j = index % yCount;

      Offset topLeft = Offset(
        i * (maxSideLength + gap),
        j * (maxSideLength + gap),
      ); // add randomized offset
      Offset topRight =
          topLeft + Offset(maxSideLength, 0); // add randomized offset
      Offset bottomRight = topLeft +
          Offset(maxSideLength, maxSideLength); // add randomized offset
      Offset bottomLeft =
          topLeft + Offset(0, maxSideLength); // add randomized offset

      final repetition =
          enableRepetition ? random.nextInt(10) + minRepetition : 1;

      for (int count = 0; count < repetition; count++) {
        if (enableColors) {
          paint.color = HSLColor.fromAHSL(
            1,
            random.nextInt(360).toDouble(),
            saturation,
            lightness,
          ).toColor();
        }
        // add randomized offset to each point
        topLeft += _randomOffsetFromRange(maxCornersOffset);
        topRight += _randomOffsetFromRange(maxCornersOffset);
        bottomRight += _randomOffsetFromRange(maxCornersOffset);
        bottomLeft += _randomOffsetFromRange(maxCornersOffset);

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
    }
    canvas.restore();
  }

  Offset _randomOffsetFromRange(double maxOffset, [double? minOffset]) {
    minOffset ??= -maxOffset;
    return Offset(
      minOffset + random.nextDouble() * (maxOffset - minOffset),
      minOffset + random.nextDouble() * (maxOffset - minOffset),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

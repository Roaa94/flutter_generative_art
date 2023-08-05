import 'dart:math';

import 'package:flutter/material.dart';

class RecursiveSquaresGrid extends StatelessWidget {
  const RecursiveSquaresGrid({
    super.key,
    this.side = 80,
    this.strokeWidth = 2,
    this.gap = 5,
    this.minSquareSideFraction = 0.2,
    this.saturation = 0.7,
    this.lightness = 0.5,
    this.enableColors = true,
  });

  final double side;
  final double strokeWidth;
  final double gap;
  final double saturation;
  final double lightness;
  final double minSquareSideFraction;
  final bool enableColors;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox.expand(
        child: CustomPaint(
          painter: RecursiveSquaresCustomPainter(
            sideLength: side,
            strokeWidth: strokeWidth,
            gap: gap,
            saturation: saturation,
            lightness: lightness,
            enableColors: enableColors,
            minSquareSideFraction: minSquareSideFraction,
          ),
        ),
      ),
    );
  }
}

class RecursiveSquaresCustomPainter extends CustomPainter {
  RecursiveSquaresCustomPainter({
    this.sideLength = 80,
    this.strokeWidth = 2,
    this.gap = 10,
    this.saturation = 0.7,
    this.lightness = 0.5,
    this.enableColors = true,
    this.minSquareSideFraction = 0.2,
  }) : minSideLength = sideLength * minSquareSideFraction;

  final double sideLength;
  final double strokeWidth;
  final double gap;
  final double minSideLength;
  final double saturation;
  final double lightness;
  final double minSquareSideFraction;
  final bool enableColors;

  static final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final xCount = ((size.width + gap) / (sideLength + gap)).floor();
    final yCount = ((size.height + gap) / (sideLength + gap)).floor();
    final contentSize = Size(
      (xCount * sideLength) + ((xCount - 1) * gap),
      (yCount * sideLength) + ((yCount - 1) * gap),
    );
    final offset = Offset(
      (size.width - contentSize.width) / 2,
      (size.height - contentSize.height) / 2,
    );

    final totalCount = xCount * yCount;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final depth = random.nextInt(5) + 5;

    for (int index = 0; index < totalCount; index++) {
      int i = index ~/ yCount;
      int j = index % yCount;

      drawNestedSquares2(
        canvas,
        Offset(
          (i * (sideLength + gap)),
          (j * (sideLength + gap)),
        ),
        sideLength,
        paint,
        depth,
      );
    }
    canvas.restore();
  }

  void drawNestedSquares1(
    Canvas canvas,
    Offset start,
    double sideLength,
    Paint paint,
  ) {
    if (sideLength < minSideLength) return;

    if (enableColors) {
      paint.color = HSLColor.fromAHSL(
        1,
        random.nextInt(360).toDouble(),
        saturation,
        lightness,
      ).toColor();
    }

    canvas.drawRect(
      Rect.fromLTWH(
        start.dx,
        start.dy,
        sideLength,
        sideLength,
      ),
      paint,
    );

    // calculate the side length for the next square randomly
    final nextSideLength = sideLength * (random.nextDouble() * 0.5 + 0.5);

    final nextStart = Offset(
      start.dx + sideLength / 2 - nextSideLength / 2,
      start.dy + sideLength / 2 - nextSideLength / 2,
    );

    // recursive call with the next side length and starting point
    drawNestedSquares1(canvas, nextStart, nextSideLength, paint);
  }

  void drawNestedSquares2(
    Canvas canvas,
    Offset start,
    double sideLength,
    Paint paint,
    int depth,
  ) {
    if (sideLength < minSideLength || depth <= 0) return;

    if (enableColors) {
      paint.color = HSLColor.fromAHSL(
        1,
        random.nextInt(360).toDouble(),
        saturation,
        lightness,
      ).toColor();
    }

    canvas.drawRect(
      Rect.fromLTWH(
        start.dx,
        start.dy,
        sideLength,
        sideLength,
      ),
      paint,
    );

    // calculate the side length for the next square randomly
    final nextSideLength = sideLength * (random.nextDouble() * 0.5 + 0.5);

    final nextStart = Offset(
      start.dx + sideLength / 2 - nextSideLength / 2,
      start.dy + sideLength / 2 - nextSideLength / 2,
    );

    // recursive call with the next side length and starting point
    drawNestedSquares2(canvas, nextStart, nextSideLength, paint, depth - 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

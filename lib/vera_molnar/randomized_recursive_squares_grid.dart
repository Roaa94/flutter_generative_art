import 'dart:math';

import 'package:flutter/material.dart';

class RandomizedRecursiveSquaresGrid extends StatelessWidget {
  const RandomizedRecursiveSquaresGrid({
    super.key,
    this.side = 80,
    this.strokeWidth = 2,
    this.gap = 5,
    this.minSquareSideFraction = 0.2,
  });

  final double side;
  final double strokeWidth;
  final double gap;
  final double minSquareSideFraction;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _RecursiveSquaresCustomPainter(
            sideLength: side,
            strokeWidth: strokeWidth,
            gap: gap,
            minSquareSideFraction: minSquareSideFraction,
          ),
        ),
      ),
    );
  }
}

class _RecursiveSquaresCustomPainter extends CustomPainter {
  _RecursiveSquaresCustomPainter({
    this.sideLength = 80,
    this.strokeWidth = 2,
    this.gap = 10,
    this.minSquareSideFraction = 0.2,
  }) : minSideLength = sideLength * minSquareSideFraction;

  final double sideLength;
  final double strokeWidth;
  final double gap;
  final double minSideLength;
  final double minSquareSideFraction;

  static final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Calculate the number of squares that can fit on the horizontal axis
    final xCount = ((size.width + gap) / (sideLength + gap)).floor();

    // Calculate the number of squares that can fit on the vertical axis
    final yCount = ((size.height + gap) / (sideLength + gap)).floor();

    // Calculate the size of the grid of squares
    final contentSize = Size(
      (xCount * sideLength) + ((xCount - 1) * gap),
      (yCount * sideLength) + ((yCount - 1) * gap),
    );

    // Calculate the offset from which we should start painting
    // the grid so that it is eventually centered
    final offset = Offset(
      (size.width - contentSize.width) / 2,
      (size.height - contentSize.height) / 2,
    );

    final totalCount = xCount * yCount;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // Introduced a randomized `depth` value that will randomize
    // the side length of the smallest square
    final depth = random.nextInt(5) + 5;

    for (int index = 0; index < totalCount; index++) {
      int i = index ~/ yCount;
      int j = index % yCount;

      // Recursively draw squares
      drawNestedSquares(
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

  void drawNestedSquares(
    Canvas canvas,
    Offset start,
    double sideLength,
    Paint paint,
    int depth,
  ) {
    // Recursively draw squares until the side of the square
    // reaches the minimum defined by the `minSideLength` input
    // Or until the `depth` reaches 0
    if (sideLength < minSideLength || depth <= 0) return;

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

    // recursive call with the next side length, starting point & `depth`
    drawNestedSquares(canvas, nextStart, nextSideLength, paint, depth - 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

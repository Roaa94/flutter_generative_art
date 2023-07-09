import 'package:flutter/material.dart';

class RotatedSquaresGrid extends StatelessWidget {
  const RotatedSquaresGrid({
    super.key,
    this.sideLength = 80,
    this.strokeWidth = 2,
    this.gap = 30,
  });

  final double sideLength;
  final double strokeWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RotatedSquaresCustomPainter(
        sideLength: sideLength,
        strokeWidth: strokeWidth,
        gap: gap,
      ),
    );
  }
}

class RotatedSquaresCustomPainter extends CustomPainter {
  RotatedSquaresCustomPainter({
    this.sideLength = 80,
    this.strokeWidth = 2,
    this.gap = 30,
  });

  final double sideLength;
  final double strokeWidth;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
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
    for (int index = 0; index < totalCount; index++) {
      int i = index ~/ yCount;
      int j = index % yCount;

      canvas.drawRect(
        Rect.fromLTWH(
          (i * (sideLength + gap)),
          (j * (sideLength + gap)),
          sideLength,
          sideLength,
        ),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

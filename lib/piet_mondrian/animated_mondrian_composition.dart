import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/mondrian_composition_data.dart';

const mondrianColors = [
  Color(0xff225095),
  Color(0xfffac901),
  Color(0xffdd0100),
  Colors.white,
];

class AnimatedMondrianComposition extends StatelessWidget {
  const AnimatedMondrianComposition({
    super.key,
    this.rectanglesCount = 10,
  });

  final int rectanglesCount;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: CustomPaint(
        painter: PietCompositionCustomPainter(
          rectanglesCount: rectanglesCount,
        ),
      ),
    );
  }
}

class PietCompositionCustomPainter extends CustomPainter {
  PietCompositionCustomPainter({
    this.rectanglesCount = 10,
  });

  final int rectanglesCount;
  static final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final composition = generateComposition(Offset.zero, size, rectanglesCount);

    for (final rect in composition.rectangles) {
      canvas.drawRect(
        Rect.fromPoints(rect[0], rect[1]),
        Paint()..color = mondrianColors[random.nextInt(mondrianColors.length)],
      );
    }

    for (final line in composition.lines) {
      canvas.drawLine(line[0], line[1], Paint()..strokeWidth = 20);
    }
  }

  MondrianCompositionData generateComposition(
    Offset origin,
    Size size,
    int totalRects,
  ) {
    // Initialize with the entire canvas as one big rectangle
    List<List<Offset>> totalRectsList = [
      [origin, Offset(origin.dx + size.width, origin.dy + size.height)]
    ];
    List<List<Offset>> totalLines = [];

    while (totalRectsList.length < totalRects) {
      // Randomly select one of the existing rectangles
      int index = random.nextInt(totalRectsList.length);
      List<Offset> rect = totalRectsList[index];

      // Calculate the size of the selected rectangle
      Size rectSize = Size(
        (rect[1].dx - rect[0].dx).abs(),
        (rect[1].dy - rect[0].dy).abs(),
      );

      // Decide whether to split horizontally or vertically, favoring the longer side
      bool splitHorizontally = rectSize.width < rectSize.height;

      if (splitHorizontally) {
        // Split horizontally
        final yDivision = random.nextInt((rectSize.height * 0.5).round()) +
            (rectSize.height * 0.25).round();
        final hOffset1 = Offset(rect[0].dx, rect[0].dy + yDivision);
        final hOffset2 = Offset(rect[1].dx, rect[0].dy + yDivision);
        totalLines.add([hOffset1, hOffset2]);
        totalRectsList[index] = [rect[0], hOffset2];
        totalRectsList.add([hOffset1, rect[1]]);
      } else {
        // Split vertically
        final xDivision = random.nextInt((rectSize.width * 0.5).round()) +
            (rectSize.width * 0.25).round();
        final vOffset1 = Offset(rect[0].dx + xDivision, rect[0].dy);
        final vOffset2 = Offset(rect[0].dx + xDivision, rect[1].dy);
        totalLines.add([vOffset1, vOffset2]);
        totalRectsList[index] = [rect[0], vOffset2];
        totalRectsList.add([vOffset1, rect[1]]);
      }
    }

    return MondrianCompositionData(
      rectangles: totalRectsList,
      lines: totalLines,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

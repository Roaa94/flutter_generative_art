import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/mondrian_composition_data.dart';

const mondrianColors = [
  Color(0xff225095),
  Color(0xfffac901),
  Color(0xffdd0100),
  Colors.white,
];

class MondrianComposition extends StatelessWidget {
  const MondrianComposition({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: CustomPaint(
        painter: PietCompositionCustomPainter(),
      ),
    );
  }
}

class PietCompositionCustomPainter extends CustomPainter {
  static final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final composition = generateComposition(Offset.zero, size, 3);

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
    int depth,
  ) {
    if (size.width < 300 || size.height < 300) {
      return MondrianCompositionData(
        rectangles: [
          [
            origin,
            Offset(
              origin.dx + size.width,
              origin.dy + size.height,
            )
          ]
        ],
      );
    }

    final xDivision = random.nextInt(5) + 2;
    final yDivision = random.nextInt(5) + 2;

    final vOffset1 = Offset(origin.dx + size.width / xDivision, origin.dy);
    final vOffset2 =
        Offset(origin.dx + size.width / xDivision, origin.dy + size.height);
    final hOffset1 = Offset(origin.dx, origin.dy + size.height / yDivision);
    final hOffset2 =
        Offset(origin.dx + size.width, origin.dy + size.height / yDivision);

    final intersection = Offset(vOffset1.dx, hOffset1.dy);
    final end = Offset(origin.dx + size.width, origin.dy + size.height);

    final rects = [
      [origin, intersection],
      [hOffset1, vOffset2],
      [vOffset1, hOffset2],
      [intersection, end],
    ];

    List<List<Offset>> totalRects = [];
    List<List<Offset>> totalLines = [];

    for (final rect in rects) {
      final rectSize = Size(
        (rect[1].dx - rect[0].dx).abs(),
        (rect[1].dy - rect[0].dy).abs(),
      );

      MondrianCompositionData subComposition =
          generateComposition(rect[0], rectSize, depth - 1);
      totalLines.addAll(subComposition.lines);

      if (subComposition.rectangles.isEmpty && depth == 1) {
        totalRects.add(rect);
      } else {
        totalRects.addAll(subComposition.rectangles);
      }
    }

    final lines = [
      [vOffset1, vOffset2],
      [hOffset1, hOffset2],
    ];

    totalLines.addAll(lines);

    return MondrianCompositionData(rectangles: totalRects, lines: totalLines);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

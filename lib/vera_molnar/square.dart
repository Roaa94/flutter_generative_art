import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  const Square({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: SquareCustomPainter(),
      ),
    );
  }
}

class SquareCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final center = Offset(size.width / 2, size.height / 2);

    final side = size.shortestSide * 0.8;

    // fromCenter(/*...*/)
    // canvas.drawRect(
    //   Rect.fromCenter(
    //     center: center,
    //     width: side,
    //     height: side,
    //   ),
    //   paint,
    // );

    // fromCircle(/*...*/)
    // canvas.drawRect(
    //   Rect.fromCircle(
    //     center: center,
    //     radius: side / 2,
    //   ),
    //   paint,
    // );

    // fromPoints(/*...*/)
    canvas.save();
    // canvas.translate(center.dx, center.dy);
    canvas.drawRect(
      Rect.fromPoints(
        Offset(-side / 2, -side / 2),
        Offset(side / 2, side / 2),
      ),
      paint,
    );
    canvas.restore();

    // fromLTRB(/*...*/)
    // canvas.save();
    // canvas.translate(center.dx, center.dy);
    // canvas.drawRect(
    //   Rect.fromLTRB(-side, -side, side, side),
    //   paint,
    // );
    // canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

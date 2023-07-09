import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/polygon.dart';
import 'package:flutter_generative_art/vera_molnar/utils.dart';

class DistortedPolygonSet extends StatefulWidget {
  const DistortedPolygonSet({
    super.key,
    this.maxCornersOffset = 20,
    this.strokeWidth = 2,
    this.enableRepetition = true,
    this.enableColors = false,
    this.minRepetition = 20,
    this.child,
    this.minSquareSideFraction = 0.8,
  });

  final double maxCornersOffset;
  final double strokeWidth;
  final double minSquareSideFraction;
  final bool enableRepetition;
  final bool enableColors;
  final int minRepetition;
  final Widget? child;

  @override
  State<DistortedPolygonSet> createState() => _DistortedPolygonSetState();
}

class _DistortedPolygonSetState extends State<DistortedPolygonSet>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  static final Random random = Random();
  late final int repetition;

  @override
  void initState() {
    super.initState();
    repetition =
        widget.enableRepetition ? random.nextInt(10) + widget.minRepetition : 1;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.black,
        child: CustomPaint(
          painter: DistortedPolygonSetCustomPainter(
            polygons: generateDistortedPolygonsSet(
              random,
              enableColors: widget.enableColors,
              maxSideLength: size.shortestSide * widget.minSquareSideFraction,
              maxCornersOffset: widget.maxCornersOffset,
              repetition: repetition,
            ),
            strokeWidth: widget.strokeWidth,
            animationController: animationController,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class DistortedPolygonSetCustomPainter extends CustomPainter {
  DistortedPolygonSetCustomPainter({
    required this.polygons,
    this.strokeWidth = 2,
    required AnimationController animationController,
  }) : super(repaint: animationController) {
    polygonAnimations = generatePolygonAnimations(polygons, animationController);
  }

  late final List<Animation<double>> polygonAnimations;
  final List<Polygon> polygons;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < polygons.length; i++) {
      paint.color = polygons[i]
          .color
          .withOpacity(polygons[i].level * polygonAnimations[i].value);
      canvas.save();
      canvas.translate(
          center.dx - polygons[i].center.dx, center.dy - polygons[i].center.dy);
      canvas.drawPoints(
        PointMode.polygon,
        polygons[i].getLerpedPoints(1 - polygonAnimations[i].value),
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

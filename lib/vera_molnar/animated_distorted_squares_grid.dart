import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/polygon.dart';
import 'package:flutter_generative_art/vera_molnar/utils.dart';

class AnimatedDistortedPolygonsGrid extends StatefulWidget {
  const AnimatedDistortedPolygonsGrid({
    super.key,
    this.maxSideLength = 80,
    this.strokeWidth = 1,
    this.gap = 30,
    this.maxCornersOffset = 4,
    this.saturation = 0.7,
    this.lightness = 0.5,
    this.enableRepetition = true,
    this.enableAnimation = false,
    this.enableColors = false,
    this.minRepetition = 10,
    this.oneColorPerSet = false,
  });

  final double maxSideLength;
  final double strokeWidth;
  final double gap;
  final double maxCornersOffset;
  final double saturation;
  final double lightness;
  final bool enableRepetition;
  final bool enableColors;
  final bool enableAnimation;
  final int minRepetition;
  final bool oneColorPerSet;

  @override
  State<AnimatedDistortedPolygonsGrid> createState() =>
      _AnimatedDistortedPolygonsGridState();
}

class _AnimatedDistortedPolygonsGridState
    extends State<AnimatedDistortedPolygonsGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  static final Random random = Random();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;
              final xCount = ((size.width + widget.gap) /
                      (widget.maxSideLength + widget.gap))
                  .floor();
              final yCount = ((size.height + widget.gap) /
                      (widget.maxSideLength + widget.gap))
                  .floor();

              return CustomPaint(
                painter: PolygonsCustomPainter(
                  animationController: animationController,
                  maxSideLength: widget.maxSideLength,
                  maxCornersOffset: widget.maxCornersOffset,
                  random: random,
                  minRepetition: widget.minRepetition,
                  enableRepetition: widget.enableRepetition,
                  enableColors: widget.enableColors,
                  enableAnimation: widget.enableAnimation,
                  strokeWidth: widget.strokeWidth,
                  lightness: widget.lightness,
                  saturation: widget.saturation,
                  gap: widget.gap,
                  oneColorPerSet: widget.oneColorPerSet,
                  xCount: xCount,
                  yCount: yCount,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PolygonsCustomPainter extends CustomPainter {
  PolygonsCustomPainter({
    required AnimationController animationController,
    this.maxSideLength = 80,
    this.strokeWidth = 2,
    this.gap = 10,
    this.xCount = 0,
    this.yCount = 0,
    required this.random,
    this.maxCornersOffset = 3,
    this.enableRepetition = true,
    this.enableColors = true,
    this.minRepetition = 10,
    this.lightness = 0.5,
    this.saturation = 0.7,
    this.enableAnimation = true,
    this.oneColorPerSet = false,
  }) : super(repaint: animationController) {
    polygons = generatePolygonSets(
      random,
      xCount: xCount,
      yCount: yCount,
      maxSideLength: maxSideLength,
      maxCornersOffset: maxCornersOffset,
      enableRepetition: enableRepetition,
      enableColors: enableColors,
      minRepetition: minRepetition,
      oneColorPerSet: oneColorPerSet,
      lightness: lightness,
      saturation: saturation,
      gap: gap,
    );
    polygonAnimations =
        generatePolygonAnimations(polygons, animationController);
  }

  final Random random;
  final double maxSideLength;
  final double strokeWidth;
  final double lightness;
  final double saturation;
  final double gap;
  final double maxCornersOffset;
  late final List<Animation<double>> polygonAnimations;
  late final List<Polygon> polygons;
  final int xCount;
  final int yCount;
  final bool enableRepetition;
  final bool enableAnimation;
  final bool oneColorPerSet;
  final bool enableColors;
  final int minRepetition;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final contentSize = Size(
      (xCount * maxSideLength) + ((xCount - 1) * gap),
      (yCount * maxSideLength) + ((yCount - 1) * gap),
    );
    final offset = Offset(
      (size.width - contentSize.width) / 2,
      (size.height - contentSize.height) / 2,
    );

    canvas.save();
    // Center canvas
    canvas.translate(offset.dx, offset.dy);

    for (int i = 0; i < polygons.length; i++) {
      final opacity = enableAnimation
          ? (polygons[i].level * polygonAnimations[i].value * 0.7)
          : (polygons[i].level * 0.7);
      paint.color = polygons[i].color.withOpacity(opacity);
      final value = enableAnimation
          ? 1 - polygonAnimations[i].value
          : (0.5 * sin(polygons[i].location.x * 2 * pi) + 0.5);
      canvas.drawPoints(
        PointMode.polygon,
        polygons[i].getLerpedPoints(value),
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

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/polygon.dart';
import 'package:flutter_generative_art/vera_molnar/utils.dart';

class GalleryPolygonsGrid extends StatefulWidget {
  const GalleryPolygonsGrid({
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
    this.images = const [],
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
  final List<ui.Image> images;

  @override
  State<GalleryPolygonsGrid> createState() => _GalleryPolygonsGridState();
}

class _GalleryPolygonsGridState extends State<GalleryPolygonsGrid>
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
    // animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.black,
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
                images: widget.images,
              ),
            );
          },
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
    this.images = const [],
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
      images: images,
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
  final List<ui.Image> images;
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
      final points = polygons[i].getLerpedPoints(value);
      if (polygons[i].image != null) {
        final path = Path();
        for (int j = 0; j < points.length; j++) {
          if (j == 0) path.moveTo(points[j].dx, points[j].dy);
          path.lineTo(points[j].dx, points[j].dy);
        }
        canvas.save();
        canvas.clipPath(path);
        canvas.drawImage(polygons[i].image!, points[0], Paint());
        canvas.restore();
      }
      canvas.drawPoints(
        ui.PointMode.polygon,
        points,
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

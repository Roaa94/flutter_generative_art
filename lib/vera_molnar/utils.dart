import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art/models/location.dart';
import 'package:flutter_generative_art/models/polygon.dart';

Offset randomOffsetFromRange(
  Random random,
  double maxOffset, [
  double? minOffset,
]) {
  minOffset ??= -maxOffset;
  return Offset(
    minOffset + random.nextDouble() * (maxOffset - minOffset),
    minOffset + random.nextDouble() * (maxOffset - minOffset),
  );
}

List<Polygon> generatePolygonSets(
  Random random, {
  required int xCount,
  required int yCount,
  required double maxSideLength,
  required double maxCornersOffset,
  required double gap,
  bool enableColors = true,
  double saturation = 0.7,
  double lightness = 0.5,
  bool enableRepetition = true,
  bool oneColorPerSet = false,
  int minRepetition = 10,
  List<ui.Image> images = const [],
}) {
  List<ui.Image> usedImages = images;
  List<Polygon> polygons = [];
  final totalCount = xCount * yCount;
  final repetition = enableRepetition ? random.nextInt(10) + minRepetition : 1;
  for (int index = 0; index < totalCount; index++) {
    int i = index ~/ yCount;
    int j = index % yCount;

    Offset start = Offset(
      i * (maxSideLength + gap),
      j * (maxSideLength + gap),
    );

    final location = Location(
      x: i / xCount,
      y: j / yCount,
    );
    var imagesSet = <ui.Image>[];
    if (images.isNotEmpty) {
      var startIndex = random.nextInt(images.length);
      var endIndex = min(startIndex + repetition, images.length);
      imagesSet = usedImages.sublist(startIndex, endIndex).toList();
    }
    polygons.addAll(
      generateDistortedPolygonsSet(
        random,
        start: start,
        maxSideLength: maxSideLength,
        maxCornersOffset: maxCornersOffset,
        repetition: repetition,
        enableColors: enableColors,
        saturation: saturation,
        lightness: lightness,
        location: location,
        oneColorPerSet: oneColorPerSet,
        images: imagesSet,
      ),
    );
  }
  return polygons;
}

List<Polygon> generateDistortedPolygonsSet(
  Random random, {
  required double maxSideLength,
  required double maxCornersOffset,
  int repetition = 1,
  Offset start = Offset.zero,
  bool enableColors = true,
  double saturation = 0.7,
  double lightness = 0.5,
  Location location = Location.one,
  bool oneColorPerSet = false,
  List<ui.Image> images = const [],
}) {
  List<Polygon> polygons = [];
  Offset squareTopLeft = start;
  Offset squareTopRight = squareTopLeft + Offset(maxSideLength, 0);
  Offset squareBottomRight =
      squareTopLeft + Offset(maxSideLength, maxSideLength);
  Offset squareBottomLeft = squareTopLeft + Offset(0, maxSideLength);

  Offset topLeft = squareTopLeft;
  Offset topRight = squareTopRight;
  Offset bottomRight = squareBottomRight;
  Offset bottomLeft = squareBottomLeft;
  late Color color;
  if (oneColorPerSet) {
    color = enableColors
        ? HSLColor.fromAHSL(
            1,
            random.nextInt(360).toDouble(),
            saturation,
            lightness,
          ).toColor()
        : Colors.white;
  }

  for (int i = 0; i < repetition; i++) {
    topLeft += randomOffsetFromRange(random, maxCornersOffset);
    topRight += randomOffsetFromRange(random, maxCornersOffset);
    bottomRight += randomOffsetFromRange(random, maxCornersOffset);
    bottomLeft += randomOffsetFromRange(random, maxCornersOffset);
    final level = i / (repetition - 1);
    if (!oneColorPerSet) {
      color = enableColors
          ? HSLColor.fromAHSL(
              1,
              random.nextInt(360).toDouble(),
              saturation,
              lightness,
            ).toColor()
          : Colors.white;
    }

    polygons.add(
      Polygon(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
        topLeftOrigin: squareTopLeft,
        topRightOrigin: squareTopRight,
        bottomRightOrigin: squareBottomRight,
        bottomLeftOrigin: squareBottomLeft,
        level: level,
        location: location,
        color: color,
        image: i <= images.length - 1 ? images[i] : null,
      ),
    );
  }
  return polygons;
}

List<Animation<double>> generatePolygonAnimations(
  List<Polygon> polygons,
  AnimationController animationController,
) {
  return List.generate(
    polygons.length,
    (i) {
      return Tween<double>(begin: 0.1, end: 1).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(
            polygons[i].animationStart,
            polygons[i].animationEnd,
            curve: Curves.easeInOut,
          ),
        ),
      );
    },
  );
}

List<Animation<double>> generateDistortedPolygonAnimations(
  Random random,
  List<Polygon> polygons,
  AnimationController animationController,
) {
  final locations = polygons.map((e) => e.location).toList();
  return List.generate(
    polygons.length,
    (i) {
      final begin =
          locations[random.nextInt(locations.length)].y * polygons[i].level;
      final end = (begin + 0.2) >= 1.0 ? 1.0 : (begin + 0.2);
      return Tween<double>(begin: 0.1, end: 1).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(
            begin,
            end,
            curve: Curves.easeInOut,
          ),
        ),
      );
    },
  );
}

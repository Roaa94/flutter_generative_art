import 'package:flutter/material.dart';

class MondrianCompositionData {
  const MondrianCompositionData({
    this.rectangles = const [],
    this.lines = const [],
  });

  final List<List<Offset>> rectangles;
  final List<List<Offset>> lines;
}

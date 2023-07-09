import 'package:flutter/material.dart';
import 'package:flutter_generative_art/vera_molnar/distorted_polygon.dart';
import 'package:flutter_generative_art/vera_molnar/distorted_polygon_set.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DistortedPolygonSet(
        minSquareSideFraction: 0.9,
        minRepetition: 50,
        enableColors: true,
        maxCornersOffset: 30,
        child: Center(
          child: DistortedPolygon(
            minSquareSideFraction: 0.4,
            color: Colors.white.withOpacity(0.4),
            child: Text(
              'Get Started...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontFamily: 'Poppins',
                decoration: TextDecoration.underline,
                decorationColor: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

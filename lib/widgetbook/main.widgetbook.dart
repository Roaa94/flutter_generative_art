import 'package:flutter/material.dart';
import 'package:flutter_generative_art/vera_molnar/get_started_page.dart';
import 'package:flutter_generative_art/piet_mondrian/mondrian_composition.dart';
import 'package:flutter_generative_art/piet_mondrian/random_children_mondrian_composition.dart'
    as random;
import 'package:flutter_generative_art/styles/themes.dart';
import 'package:flutter_generative_art/vera_molnar/animated_distorted_squares_grid.dart';
import 'package:flutter_generative_art/vera_molnar/distorted_polygons_grid.dart';
import 'package:flutter_generative_art/vera_molnar/distorted_polygon.dart';
import 'package:flutter_generative_art/vera_molnar/distorted_polygon_set.dart';
import 'package:flutter_generative_art/vera_molnar/recursive_squares_grid.dart';
import 'package:flutter_generative_art/vera_molnar/square.dart';
import 'package:flutter_generative_art/vera_molnar/squares_grid.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: AppThemes.lightTheme,
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: AppThemes.darkTheme,
            ),
          ],
        ),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Vera Molnar',
          children: [
            WidgetbookComponent(
              name: 'Square',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Square(),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SquaresGrid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const SquaresGrid(),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'RecursiveSquaresGrid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: RecursiveSquaresGrid(
                        enableColors: context.knobs.boolean(
                          label: 'Enable Colors',
                          initialValue: true,
                        ),
                        strokeWidth: context.knobs.double.slider(
                          label: 'Stroke Width',
                          initialValue: 1.0,
                          min: 0.5,
                          max: 3.5,
                          divisions: 6,
                        ),
                        side: context.knobs.double.slider(
                          label: 'Square Side Length',
                          initialValue: 80,
                          min: 30,
                          max: 200,
                        ),
                        gap: context.knobs.double.slider(
                          label: 'Gap',
                          initialValue: 5,
                          min: 5,
                          max: 50,
                        ),
                        saturation: context.knobs.double.slider(
                          label: 'Saturation',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 0.7,
                        ),
                        lightness: context.knobs.double.slider(
                          label: 'Lightness',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 0.5,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'DistortedPolygon',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: DistortedPolygon(
                        strokeWidth: context.knobs.double.slider(
                          label: 'Stroke Width',
                          initialValue: 2.0,
                          min: 0.5,
                          max: 3.5,
                          divisions: 6,
                        ),
                        maxCornersOffset: context.knobs.double.slider(
                          label: 'Max Corners Offset',
                          initialValue: 20,
                          min: 0,
                          max: 100,
                          divisions: 100,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'DistortedPolygonsGrid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: DistortedPolygonsGrid(
                        enableRepetition: context.knobs.boolean(
                          label: 'Enable Repetition',
                          initialValue: true,
                        ),
                        enableColors: context.knobs.boolean(
                          label: 'Enable Colors',
                          initialValue: true,
                        ),
                        minRepetition: context.knobs.double
                            .slider(
                              label: 'Minimum Repetition',
                              initialValue: 10,
                              min: 1,
                              max: 20,
                              divisions: 19,
                            )
                            .toInt(),
                        strokeWidth: context.knobs.double.slider(
                          label: 'Stroke Width',
                          initialValue: 1.0,
                          min: 0.5,
                          max: 3.5,
                          divisions: 6,
                        ),
                        maxSideLength: context.knobs.double.slider(
                          label: 'Square Side Length',
                          initialValue: 80,
                          min: 30,
                          max: 200,
                        ),
                        gap: context.knobs.double.slider(
                          label: 'Gap',
                          initialValue: 30,
                          min: 5,
                          max: 50,
                        ),
                        maxCornersOffset: context.knobs.double.slider(
                          label: 'Max Corners Offset',
                          initialValue: 5,
                          min: 0,
                          max: 30,
                          divisions: 30,
                        ),
                        saturation: context.knobs.double.slider(
                          label: 'Saturation',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 0.7,
                        ),
                        lightness: context.knobs.double.slider(
                          label: 'Lightness',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 0.5,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'DistortedPolygonSet',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: DistortedPolygonSet(
                        minRepetition: context.knobs.double
                            .slider(
                              label: 'Minimum Repetition',
                              initialValue: 30,
                              min: 1,
                              max: 50,
                              divisions: 49,
                            )
                            .toInt(),
                        strokeWidth: context.knobs.double.slider(
                          label: 'Stroke Width',
                          initialValue: 1.0,
                          min: 0.5,
                          max: 3.5,
                          divisions: 6,
                        ),
                        maxCornersOffset: context.knobs.double.slider(
                          label: 'Max Corners Offset',
                          initialValue: 20,
                          min: 0,
                          max: 100,
                          divisions: 100,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AnimatedDistortedPolygonsGrid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: AnimatedDistortedPolygonsGrid(
                        enableColors: true,
                        enableAnimation: true,
                        oneColorPerSet: context.knobs.boolean(
                          label: 'One Colors Per Set',
                          initialValue: false,
                        ),
                        minRepetition: context.knobs.double
                            .slider(
                              label: 'Minimum Repetition',
                              initialValue: 50,
                              min: 1,
                              max: 100,
                              divisions: 99,
                            )
                            .toInt(),
                        strokeWidth: context.knobs.double.slider(
                          label: 'Stroke Width',
                          initialValue: 1.0,
                          min: 0.5,
                          max: 3.5,
                          divisions: 6,
                        ),
                        maxSideLength: context.knobs.double.slider(
                          label: 'Square Side Length',
                          initialValue: 80,
                          min: 30,
                          max: 200,
                        ),
                        gap: context.knobs.double.slider(
                          label: 'Gap',
                          initialValue: 30,
                          min: 0,
                          max: 50,
                        ),
                        maxCornersOffset: context.knobs.double.slider(
                          label: 'Max Corners Offset',
                          initialValue: 3,
                          min: 0,
                          max: 12,
                          divisions: 12,
                        ),
                        saturation: context.knobs.double.slider(
                          label: 'Saturation',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 0.5,
                        ),
                        lightness: context.knobs.double.slider(
                          label: 'Lightness',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 0.5,
                        ),
                      ),
                    );
                  },
                ),
                WidgetbookUseCase(
                  name: 'Static',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const AnimatedDistortedPolygonsGrid(
                        enableColors: true,
                        minRepetition: 30,
                      ),
                    );
                  },
                ),
                WidgetbookUseCase(
                  name: 'Static - One Color Per Set',
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const AnimatedDistortedPolygonsGrid(
                        enableColors: true,
                        oneColorPerSet: true,
                        saturation: 0.2,
                        minRepetition: 30,
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookCategory(
              name: 'Shaders',
              children: [
                WidgetbookComponent(
                  name: 'AnimatedPolygonsGrid',
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Playground',
                      builder: (context) => const AnimatedDistortedPolygonsGrid(
                        enableColors: true,
                        enableAnimation: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            WidgetbookCategory(
              name: 'Pages',
              children: [
                WidgetbookComponent(
                  name: 'Get Started',
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Playground',
                      builder: (context) => const GetStartedPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Piet Mondrian',
          children: [
            WidgetbookComponent(
              name: 'Composition',
              useCases: [
                WidgetbookUseCase(
                  name: 'Random Children',
                  builder: (context) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const random.MondrianComposition(),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Fixed Children',
                  builder: (context) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: MondrianComposition(
                      rectanglesCount: context.knobs.double
                          .slider(
                            label: 'Rectangles Count',
                            initialValue: 5,
                            min: 3,
                            max: 50,
                            divisions: 49,
                          )
                          .toInt(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        WidgetbookComponent(
          name: 'Colors',
          useCases: [
            WidgetbookUseCase(
              name: 'RGB',
              builder: (context) {
                return Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: ColoredBox(
                      color: Color.fromARGB(
                        context.knobs.double
                            .slider(
                              label: 'Alpha',
                              min: 0,
                              max: 255,
                              divisions: 255,
                              initialValue: 255,
                            )
                            .toInt(),
                        context.knobs.double
                            .slider(
                              label: 'R',
                              min: 0,
                              max: 255,
                              divisions: 255,
                              initialValue: 0,
                            )
                            .toInt(),
                        context.knobs.double
                            .slider(
                              label: 'G',
                              min: 0,
                              max: 255,
                              divisions: 255,
                              initialValue: 0,
                            )
                            .toInt(),
                        context.knobs.double
                            .slider(
                              label: 'B',
                              min: 0,
                              max: 255,
                              divisions: 255,
                              initialValue: 0,
                            )
                            .toInt(),
                      ),
                    ),
                  ),
                );
              },
            ),
            WidgetbookUseCase(
              name: 'HSL',
              builder: (context) {
                return Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: ColoredBox(
                      color: HSLColor.fromAHSL(
                        context.knobs.double.slider(
                          label: 'Alpha',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 1,
                        ),
                        context.knobs.double.slider(
                          label: 'Hue',
                          min: 0,
                          max: 360,
                          divisions: 100,
                          initialValue: 0,
                        ),
                        context.knobs.double.slider(
                          label: 'Saturation',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 0.7,
                        ),
                        context.knobs.double.slider(
                          label: 'Lightness',
                          min: 0,
                          max: 1.0,
                          divisions: 10,
                          initialValue: 0.5,
                        ),
                      ).toColor(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

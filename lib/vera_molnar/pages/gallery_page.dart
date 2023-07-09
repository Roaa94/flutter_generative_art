import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_generative_art/vera_molnar/gallery_polygons.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    super.key,
    this.images = const [],
  });

  final List<String> images;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<ui.Image> uiImages = [];
  bool imagesAreLoading = true;

  Future<List<ui.Image>> loadImages(List<String> images) async {
    final loadedImages = <ui.Image>[];
    for (final imagePath in images) {
      final ByteData data = await rootBundle.load(imagePath);
      final loadedImage = await loadImage(Uint8List.view(data.buffer));
      loadedImages.add(loadedImage);
    }
    return loadedImages;
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  void initState() {
    loadImages(widget.images).then((value) {
      setState(() {
        uiImages = value;
        imagesAreLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imagesAreLoading
          ? const Center(child: CircularProgressIndicator())
          : GalleryPolygonsGrid(
              enableColors: true,
              enableAnimation: true,
              maxSideLength: MediaQuery.of(context).size.width * 0.5,
              maxCornersOffset: 20,
              gap: 40,
              strokeWidth: 7,
              minRepetition: 5,
              images: uiImages,
            ),
    );
  }
}

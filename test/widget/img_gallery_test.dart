import 'dart:io';
import 'package:appartapp/widgets/img_gallery.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Img gallery testing -->', () {
    testWidgets('Img gallery has a button to add more photos', (tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
            home: ImgGallery(filesToUploadCbk: (List<File> files) {})),
      ));

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Img gallery has a Carousel slider to shown the photos',
        (tester) async {
      List<GalleryImage> testImages = [];
      testImages.add(GalleryImage(
          const Image(
              image: AssetImage(
                  '/Users/marioroca/Flutter/appartapp/assets/appart.jpg')),
          () => () {}));

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            home: ImgGallery(
          filesToUploadCbk: (List<File> files) {},
          existingImages: testImages,
        )),
      ));

      expect(find.byType(CarouselSlider), findsOneWidget);
    });

    testWidgets(
        'Img gallery has a GestureDetector to interact with the carousel',
        (tester) async {
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            home: ImgGallery(filesToUploadCbk: (List<File> files) {})),
      ));

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('Img gallery has no Carousel Slider if there are no photos',
        (tester) async {
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            home: ImgGallery(filesToUploadCbk: (List<File> files) {})),
      ));

      expect(find.byType(CarouselSlider), findsNothing);
    });
  });
}

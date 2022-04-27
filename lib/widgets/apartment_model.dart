import 'dart:ui';

import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/pages/houses.dart';
import 'package:flutter/material.dart';

class ApartmentModel extends StatefulWidget {
  //Apartment currentApartment;
  Apartment currentApartment;

  ApartmentModel({
    required this.currentApartment,
  });

  @override
  _ApartmentModel createState() => _ApartmentModel();
}

class _ApartmentModel extends State<ApartmentModel> {
  //Apartment apartment = Apartment();

  int currentIndex = 0;
  int numImages = 0;

  @override
  void initState() {
    super.initState();
    numImages = widget.currentApartment.images.length;
  }

  @override
  void didUpdateWidget(covariant ApartmentModel oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    numImages = widget.currentApartment.images.length;
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: widget.currentApartment.images[currentIndex].image,
        fit: BoxFit.cover,
      ),
    ),
    child: GestureDetector(
      onTapUp: (TapUpDetails details) {
        final RenderBox? box = context.findRenderObject() as RenderBox;
        final localOffset = box!.globalToLocal(details.globalPosition);
        final x = localOffset.dx;

        // if x is less than halfway across the screen and user is not on first image
        if (x < box.size.width / 2) {
          setState(() {
            if (currentIndex > 0) {
              setState(() {
                currentIndex--;
              });
            }
          });
        } else {
          // Assume the user tapped on the other half of the screen and check they are not on the last image
          if (currentIndex < numImages - 1) {
            setState(() {
              currentIndex++;
            });
          }
        }
      },
    ),
  );
}

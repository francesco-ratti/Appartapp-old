import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/pages/houses.dart';
import 'package:flutter/material.dart';

class ApartmentModel extends StatefulWidget {
  Apartment currentApartment;

  ApartmentModel({
    required this.currentApartment,
  });

  @override
  _ApartmentModel createState() => _ApartmentModel();
}

class _ApartmentModel extends State<ApartmentModel> {
  //Apartment apartment = Apartment();

  String currentImageUrl = "";
  int currentIndex = 0;
  int numImages = 0;

  @override
  void initState() {
    super.initState();
    numImages = widget.currentApartment.imagesUrl.length;
    currentImageUrl = widget.currentApartment.imagesUrl[0];
  }

  void displayNext() {
    if (currentIndex < numImages - 1) {
      currentImageUrl = widget.currentApartment.imagesUrl[++currentIndex];
    }
  }

  void displayPrevious() {
    if (currentIndex > 0) {
      currentImageUrl = widget.currentApartment.imagesUrl[--currentIndex];
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(currentImageUrl),
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
            displayPrevious();
          });
        } else {
          // Assume the user tapped on the other half of the screen and check they are not on the last image
          setState(() {
            displayNext();
          });
        }
      },
    ),
  );
}

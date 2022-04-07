import 'package:appartapp/classes/appartment.dart';
import 'package:flutter/material.dart';

class AppartmentModel extends StatefulWidget {
  String urlStr = "http://...";

  @override
  _AppartmentModel createState() => _AppartmentModel();
}

class _AppartmentModel extends State<AppartmentModel> {
  Appartment appartment = Appartment();

  @override
  void initState() {
    super.initState();
    appartment.initializeForTesting();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(appartment.currentImage),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(onTapUp: (TapUpDetails details) {
          final RenderBox? box = context.findRenderObject() as RenderBox;
          final localOffset = box!.globalToLocal(details.globalPosition);
          final x = localOffset.dx;

          // if x is less than halfway across the screen and user is not on first image
          if (x < box.size.width / 2) {
            appartment.displayPrevious();
            setState(() {});
          } else {
            // Assume the user tapped on the other half of the screen and check they are not on the last image
            appartment.displayNext();
            setState(() {});
          }
        }),
      );
}



// Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/casa.jpeg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//       );

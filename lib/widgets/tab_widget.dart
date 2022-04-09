import 'package:appartapp/classes/apartment.dart';
import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  final Apartment currentApartment;
  final ScrollController scrollController;

  TabWidget({
    Key? key,
    required this.scrollController,
    required this.currentApartment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(16),
    controller: scrollController,
    children: [
      Text(
        currentApartment.listingTitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
      Container(
        height: 300,
        width: 300,
        child: Image.asset('assets/appart.tiff'),
      ),
      Text(currentApartment.description),
      Text("Prezzo: ${currentApartment.price}€"),
      Text("Indirizzo: ${currentApartment.address}"),
      Text("Spese incluse: ${currentApartment.additionalExpenseDetail}"),
    ],
  );
}

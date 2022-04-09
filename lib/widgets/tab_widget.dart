import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  TabWidget({
    Key? key,
    required this.scrollController,
    required this.listingTitle,
    required this.description,
    required this.price,
    required this.address,
    required this.additionalExpenseDetail
  }) : super(key: key);
  final ScrollController scrollController;
  final String listingTitle;//="Bilocale Milano";
  final String description;//="Casa molto carina, senza soffitto, senza cucina";
  final int price;//=350;
  final String address;//="Via Roma, 27";
  final String additionalExpenseDetail;//="No, pagamento trimestrale";

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(16),
    controller: scrollController,
    children: [
      Text(
        listingTitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
      Container(
        height: 300,
        width: 300,
        child: Image.asset('assets/appart.tiff'),
      ),
      Text(description),
      Text("Prezzo: ${price}€"),
      Text("Indirizzo: ${address}"),
      Text("Spese incluse: ${additionalExpenseDetail}"),
    ],
  );
}

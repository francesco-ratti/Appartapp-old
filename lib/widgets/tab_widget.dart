import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  TabWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;

  String listingTitle="Bilocale Milano";
  String description="Casa molto carina, senza soffitto, senza cucina";
  String price="350€";
  String address="Via Roma, 27";
  String additionalExpenseDetail="No, pagamento trimestrale";

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
          Text("Prezzo: ${price}"),
          Text("Indirizzo: ${address}"),
          Text("Spese incluse: ${additionalExpenseDetail}"),
        ],
      );
}

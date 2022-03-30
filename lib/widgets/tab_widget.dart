import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.all(16),
        controller: scrollController,
        children: [
          Text(
            "\nBilocale Milano",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Container(
            height: 300,
            width: 300,
            child: Image.asset('assets/appart.tiff'),
          ),
          Text(
              "QUESTO E' UN WIDGET. LO PERSONALIZZEREMO COME PIU' CI PIACE\n\n\nTutte le informazioni necessarie.\nPREZZO 350€\nINDIRIZZO: VIA ROMA, 27 \nSPESE INCLUSE: SI"),
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabWidgetLoading extends StatelessWidget {
  TabWidgetLoading({
    Key? key,
  }) : super(key: key);

  final double parentPadding = 16;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(30 + parentPadding, 10 + parentPadding,
            10 + parentPadding, 30 + parentPadding),
        child: Text(
          "Caricamento in corso...",
          //textAlign: TextAlign.center,
          style: GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
        ),
      );
}

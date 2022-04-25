import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayText extends StatelessWidget {
  final String title;
  final String content;

  DisplayText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.nunito(color: Colors.white70, fontSize: 15),
            ),
            Text(
              content,
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 20),
            ),
          ],
        ));
  }
}

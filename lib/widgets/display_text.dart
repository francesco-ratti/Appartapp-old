import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayText extends StatelessWidget {
  final String title;
  final String content;
  bool blurred;

  DisplayText(
      {Key? key,
      required this.title,
      required this.content,
      required this.blurred})
      : super(key: key);

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
            blurred
                ? Blur(
                    blur: 0.5,
                    child: Text("Content not available"),
                    blurColor: Colors.transparent)
                : Text(
                    content,
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                  ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayText extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;

  const DisplayText(
      {Key? key,
      required this.title,
      this.content,
      this.contentWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.nunito(color: Colors.white70, fontSize: 15),
            ),
            content == null
                ? const SizedBox()
                : Text(
                    content!,
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                  ),
            contentWidget == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                    child: contentWidget as Widget,
                  )
          ],
        ));
  }
}

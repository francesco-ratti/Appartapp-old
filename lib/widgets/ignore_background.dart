import 'package:flutter/material.dart';

class IgnoreBackground extends StatelessWidget {
  const IgnoreBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Container(
            //padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/thumb_down.png", width: 64, height: 64),
              ],
            )));
  }
}

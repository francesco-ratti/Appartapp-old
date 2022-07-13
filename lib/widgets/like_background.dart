import 'package:flutter/material.dart';

class LikeBackground extends StatelessWidget {
  const LikeBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Container(
            //padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset("assets/thumb_up.png", width: 64, height: 64),
              ],
            )));
  }
}

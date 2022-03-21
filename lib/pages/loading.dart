import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isFirstLaunch = true;

  void setup() async {
    await Future.delayed(Duration(seconds: 1));
    if (isFirstLaunch) {
      isFirstLaunch = false;
      Navigator.pushReplacementNamed(context, '/first', arguments: {});
    } else {
      Navigator.pushReplacementNamed(context, '/home', arguments: {});
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitSquareCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}

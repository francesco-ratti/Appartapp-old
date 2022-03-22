import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));
    bool? TourCompleted=prefs.getBool('tourcompleted');
    if (TourCompleted==true) {
      Navigator.pushReplacementNamed(context, '/login', arguments: prefs);
    } else {
      Navigator.pushReplacementNamed(context, '/first', arguments: prefs);
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

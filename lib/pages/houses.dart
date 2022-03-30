import 'package:flutter/material.dart';

class Houses extends StatefulWidget {
  Houses({required this.child});

  final Widget child;

  @override
  _Houses createState() => _Houses();
}

class _Houses extends State<Houses> {
  int _currentRoute = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/casa.jpeg',
                ),
              )),
              child:
                  Scaffold(backgroundColor: Colors.transparent, body: Center()),
            );
          },
        );
      },
    );
  }
}

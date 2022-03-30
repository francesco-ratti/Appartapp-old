import 'package:flutter/material.dart';

class Appartment extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/appart.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'Explore Houses',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
}


//USE THIS TO FULL SCREEN IMAGE

// Container(
//                 decoration: const BoxDecoration(
//                     image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage(
//                     'assets/casa.jpeg',
//                   ),
//                 )),
//               ),
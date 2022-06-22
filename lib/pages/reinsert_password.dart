import 'package:flutter/material.dart';

class InsertPassword extends StatefulWidget {
  Function(String, Function(String)) callback;

  InsertPassword(this.callback, {Key? key}) : super(key: key);

  @override
  _InsertPasswordState createState() => _InsertPasswordState();
}

class _InsertPasswordState extends State<InsertPassword> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        appBar: AppBar(
            title: const Text('Registrati')),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Reinserisci la tua password per modificare i dati")),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  controller: passwordController,
                )),
            ElevatedButton(
                child: Text("Modifica"),
                style: ElevatedButton.styleFrom(primary: Colors.brown),
                onPressed: () {
                  String password= passwordController.text.trim();
                  widget.callback(password, (res) { // TODO
                  });
                  Navigator.pop(context);
                }),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }
}

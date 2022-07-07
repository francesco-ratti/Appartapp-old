import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class InsertPassword extends StatefulWidget {
  final Function(String, Function(bool, String)) callback; //_isLoading, status
  final String description;

  InsertPassword({
    Key? key,
    required this.description,
    required this.callback,
  }) : super(key: key);

  @override
  _InsertPasswordState createState() => _InsertPasswordState();
}

class _InsertPasswordState extends State<InsertPassword> {
  final passwordController = TextEditingController();
  String _status = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inserisci la password'),
          backgroundColor: Colors.brown,
        ),
        body: ModalProgressHUD(
          child: LayoutBuilder(
              builder: (context, constraints) => ListView(children: [
                    Container(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  _status,
                                  style: const TextStyle(fontSize: 20),
                                )),
                            Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(widget.description)),
                            Padding(
                                padding: EdgeInsets.all(16.0),
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
                                  String password =
                                      passwordController.text.trim();
                                  widget.callback(password,
                                      (bool isLoading, String status) {
                                    setState(() {
                                      _status = status;
                                      _isLoading = isLoading;
                                    });
                                  });
                                }),
                          ],
                        ))
                  ])),
          inAsyncCall: _isLoading,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }
}

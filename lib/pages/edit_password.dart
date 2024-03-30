import 'package:appartapp/model/user_handler.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditPassword extends StatefulWidget {
  final Color bgColor = Colors.white;

  const EditPassword({Key? key}) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final oldPasswordController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();

  String status = "";

  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Modifica password'),
          backgroundColor: Colors.brown,
        ),
        backgroundColor: widget.bgColor,
        body: ModalProgressHUD(
          child:
              ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Inserisci la tua password attuale")),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password attuale',
                  ),
                  controller: oldPasswordController,
                )),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("La tua nuova password?")),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nuova password',
                  ),
                  controller: password1Controller,
                )),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Conferma la tua nuova password")),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Conferma password',
                  ),
                  controller: password2Controller,
                )),
            ElevatedButton(
                child: const Text("Aggiorna", style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                onPressed: () {
                  String oldPassword = oldPasswordController.text;
                  if (oldPasswordController.text.trim().isEmpty ||
                      password1Controller.text.trim().isEmpty ||
                      password2Controller.text.trim().isEmpty) {
                    setState(() {
                      status = "Inserisci la tua vecchia password e la nuova";
                    });
                    return;
                  }

                  if (password1Controller.text != password2Controller.text) {
                    setState(() {
                      status = "Le password non corrispondono";
                    });
                  } else {
                    String newPassword = password1Controller.text;
                    setState(() {
                      _isLoading = true;
                    });
                    UserHandler.updatePassword(
                        RuntimeStore().getUser()?.email ?? "",
                        oldPassword,
                        newPassword, () {
                      //onComplete
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context);
                    }, () {
                      //onError
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.restorablePush(context,
                          ErrorDialogBuilder.buildConnectionErrorRoute);
                    });
                  }
                }),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  status,
                  style: const TextStyle(fontSize: 20),
                )),
          ]),
          inAsyncCall: _isLoading,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
        ));
  }
}

import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_gender.dart';
import 'package:appartapp/model/login_handler.dart';
import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/utils_classes/email_validator.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthdayController = TextEditingController();

  String status = "";

  DateTime _birthday = DateTime.now();

  Gender? _gender;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;

    birthdayController.text =
        "${_birthday.day}/${_birthday.month}/${_birthday.year}";

    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrati', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.brown,
        ),
        backgroundColor: bgColor,
        body: ModalProgressHUD(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-Mail',
                    ),
                    controller: emailController,
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    controller: passwordController,
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                    ),
                    controller: nameController,
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cognome',
                    ),
                    controller: surnameController,
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: birthdayController,
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: _birthday,
                              lastDate: DateTime.now(),
                              firstDate: DateTime(1900))
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _birthday = value;
                          });
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data di nascita',
                    ),
                  )),
              const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: Text("Genere")),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: Row(children: [
                    // Expanded(
                    //     child:
                    DropdownButton<Gender>(
                      hint: const Text("Scegli il tuo genere"),
                      // Not necessary for Option 1
                      value: _gender,
                      onChanged: (newValue) {
                        setState(() {
                          _gender = newValue;
                        });
                      },
                      items: Gender.values.map((gender) {
                        return DropdownMenuItem(
                          child: Text(gender.toItalianString()),
                          value: gender,
                        );
                      }).toList(),
                    ) //)
                  ])),
              ElevatedButton(
                  child: const Text("Registrati", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: () {
                    setState(() {
                      status = "";
                    });

                    String email = emailController.text.trim();
                    String password = passwordController.text;
                    String name = nameController.text.trim();
                    String surname = surnameController.text.trim();

                    if ((email.isNotEmpty &&
                        password.trim().isNotEmpty &&
                        name.isNotEmpty &&
                        surname.isNotEmpty &&
                        _gender != null)) {
                      if (!EmailValidator.isEmailValid(email)) {
                        setState(() {
                          status = "Inserisci un indirizzo email valido";
                        });
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      LoginHandler.doSignup(
                          (String toWrite) {
                            setState(() {
                              _isLoading = false;
                              status = toWrite;
                            });
                          },
                          email,
                          password,
                          name,
                          surname,
                          _birthday,
                          _gender as Gender,
                          (User user) {
                            //onComplete
                            SharedPreferences sharedPreferences = RuntimeStore()
                                .getSharedPreferences() as SharedPreferences;

                            sharedPreferences.setBool("credentialslogin", true);
                            RuntimeStore().credentialsLogin = true;
                            doInitialisation(context, user, sharedPreferences);
                          },
                          () {
                            //onError
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.restorablePush(context,
                                ErrorDialogBuilder.buildConnectionErrorRoute);
                          });
                    } else {
                      setState(() {
                        status = "Incompleto. Compila tutti i campi";
                      });
                    }
                  }),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    status,
                    style: const TextStyle(fontSize: 20),
                  )),
            ],
          ),
          inAsyncCall: _isLoading,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}

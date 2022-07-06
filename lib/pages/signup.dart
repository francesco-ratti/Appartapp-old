import 'package:appartapp/classes/enum_gender.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';

//import './../SimpleTextField.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/signup";

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isLoading = false;

  void doSignup(Function(String) updateUi, String email, String password,
      String name, String surname, DateTime birthday, Gender gender) async {
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        widget.urlStr,
        data: {
          "email": email,
          "password": password,
          "name": name,
          "surname": surname,
          "birthday": birthday.millisecondsSinceEpoch.toString(),
          "gender": gender.toShortString()
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        Map responseMap = response.data;
        User user = User.fromMap(responseMap);

        SharedPreferences sharedPreferences =
            RuntimeStore().getSharedPreferences() as SharedPreferences;

        sharedPreferences.setBool("credentialslogin", true);
        RuntimeStore().credentialsLogin = true;
        doInitialisation(context, user, sharedPreferences);
      } else {
        updateUi("Impossibile iscriversi. Scegli altre credenziali.");
      }
    } on DioError {
      setState(() {
        _isLoading = false;
      });
      Navigator.restorablePush(
          context, ErrorDialogBuilder.buildConnectionErrorRoute);
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthdayController = TextEditingController();

  String status = "";

  DateTime _birthday = new DateTime.now();

  Gender? _gender = null;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;

    birthdayController.text =
        "${_birthday.day}/${_birthday.month}/${_birthday.year}";

    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrati'),
          backgroundColor: Colors.brown,
        ),
        backgroundColor: bgColor,
        body: ModalProgressHUD(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-Mail',
                    ),
                    controller: emailController,
                  )),
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
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                    ),
                    controller: nameController,
                  )),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cognome',
                    ),
                    controller: surnameController,
                  )),
              Padding(
                  padding: EdgeInsets.all(8.0),
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data di nascita',
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: Text("Genere")),
              Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: Row(children: [
                    Expanded(
                        child: DropdownButton<Gender>(
                          hint: Text("Scegli il tuo genere"),
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
                        ))
                  ])),
              ElevatedButton(
                  child: Text("Registrati"),
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    String name = nameController.text;
                    String surname = surnameController.text;

                    if ((email.length > 0 &&
                        password.length > 0 &&
                        name.length > 0 &&
                        surname.length > 0 &&
                        _gender != null)) {
                      setState(() {
                        _isLoading = true;
                      });
                      doSignup((String toWrite) {
                        setState(() {
                          status = toWrite;
                        });
                      }, email, password, name, surname, _birthday,
                          _gender as Gender);
                    } else {
                      setState(() {
                        status = "Incompleto. Compila tutti i campi";
                      });
                    }
                  }),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 20),
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

import 'package:appartapp/classes/enum_gender.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:flutter/material.dart';

//import './../SimpleTextField.dart';
import 'package:dio/dio.dart';

class Signup extends StatefulWidget {
  String urlStr = "http://172.20.10.4:8080/appartapp_war_exploded/api/signup";

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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

      if (response.statusCode != 200)
        updateUi("Failure");
      else
        updateUi("Signed up");
    } on DioError catch (e) {
      if (e.response?.statusCode != 200) {
        updateUi("Failure");
      }
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthdayController = TextEditingController();

  String status = "Not submitted yet";

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
        body: ListView(
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
        ));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}

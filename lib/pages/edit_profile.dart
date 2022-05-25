import 'dart:io';

import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/enum_gender.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:appartapp/classes/apartment_handler.dart';

import 'package:dio/dio.dart';
import '../widgets/ImgGallery.dart';

class EditProfile extends StatefulWidget {
  String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/edituser";
  Color bgColor = Colors.white;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  List<File> _images=<File>[];

  void doUpdate(Function(String) updateUi, String oldemail, String email, String oldpassword,
      String name, String surname, DateTime birthday, Gender gender) async {
    var dio = Dio();
    try {
      Response response = await dio.post(
        widget.urlStr,
        data: {
          "email": oldemail,
          "password": oldpassword,

          "newemail": email,
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
      else {
        updateUi("Updated");
        Map responseMap=response.data;

        RuntimeStore().setCredentialsByString(responseMap["email"], responseMap["password"]);
        RuntimeStore().setUser(User.fromMap(responseMap));
      }
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

  String status = "";

  User? user=RuntimeStore().getUser();

  late DateTime _birthday=new DateTime.now();

  Gender? _gender;

  @override
  void initState() {
    super.initState();

    _birthday = user!.birthday;
    _gender = user!.gender;

    emailController.text=user!.email;
    nameController.text=user!.name;
    surnameController.text=user!.surname;
  }

  @override
  Widget build(BuildContext context) {

    birthdayController.text =
    "${_birthday.day}/${_birthday.month}/${_birthday.year}";

    return Scaffold(
        appBar: AppBar(title: const Text('Il tuo profilo')),
        backgroundColor: widget.bgColor,
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: ImgGallery(callback: (imgList) {
                  _images=imgList;
                })),
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

                    doUpdate((String toWrite) {
                          setState(() {
                            status = toWrite;
                          });
                        }, RuntimeStore().getEmail() ?? email, email, password, name, surname, _birthday, _gender as Gender);
                  } else {
                    setState(() {
                      status = "Incompleto. Compila tutti i campi";
                    });
                  }
                }),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            ElevatedButton(
                child: Text("Aggiorna la password"),
                onPressed: () {
                  Navigator.pushNamed(context, "/editpassword");
                }),
            ElevatedButton(
                child: Text("Modifica informazioni locatario"),
                onPressed: () {
                  Navigator.pushNamed(context, "/edittenants");
                }),
            ElevatedButton(
                child: Text("Esci"),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  RuntimeStore().setCredentials(null);
                  RuntimeStore().getSharedPreferences()?.remove("email");
                  RuntimeStore().getSharedPreferences()?.remove("password");
                  ApartmentHandler().cookieJar=CookieJar();
                  Navigator.pushReplacementNamed(context, "/loginorsignup");
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
    emailController.dispose();
    nameController.dispose();
    surnameController.dispose();
    birthdayController.dispose();
    passwordController.dispose();
  }
}

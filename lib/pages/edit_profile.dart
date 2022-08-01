import 'dart:io';

import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_gender.dart';
import 'package:appartapp/model/login_handler.dart';
import 'package:appartapp/model/user_handler.dart';
import 'package:appartapp/pages/reinsert_password.dart';
import 'package:appartapp/utils_classes/google_authentication.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:appartapp/widgets/img_gallery.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditProfile extends StatefulWidget {
  final Color bgColor = Colors.white;

  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user = RuntimeStore().getUser();

  List<File> _images = <File>[];
  List<Function> _onSubmitCbks = <Function>[];

  bool _isLoading = false;
  bool _uploadError = false;

  int uploadCtr = 0;
  int numUploads = 0;

  void onUploadsEnd() {
    uploadCtr = 0;
    numUploads = 0;
    setState(() {
      _isLoading = false;
    });
    if (_uploadError) {
      _uploadError = false;
      Navigator.restorablePush(
          context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
    }
    LoginHandler.doLoginWithCookies().then((value) {
      User newUser = value[0];
      if (newUser != null) {
        RuntimeStore().setUser(newUser);
        setState(() {
          user = newUser;
          init();
        });
      }
    });
  }

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthdayController = TextEditingController();

  String status = "";

  late DateTime _birthday = DateTime.now();

  Gender? _gender;

  List<GalleryImage> existingImages = [];

  void init() {
    existingImages = [];

    _images = <File>[];
    _onSubmitCbks = <Function>[];

    _isLoading = false;
    _uploadError = false;

    uploadCtr = 0;
    numUploads = 0;

    _birthday = user!.birthday;
    _gender = user!.gender;

    emailController.text = user!.email;
    nameController.text = user!.name;
    surnameController.text = user!.surname;

    for (int i = 0; i < RuntimeStore().getUser()!.imagesDetails.length; i++) {
      Map im = RuntimeStore().getUser()!.imagesDetails[i];
      existingImages.add(GalleryImage(
          RuntimeStore().getUser()!.images[i],
          () => () {
                UserHandler.removeImage(
                    () {
                      uploadCtr++;
                      if (uploadCtr == numUploads) {
                        onUploadsEnd();
                      }
                    },
                    im['id'].toString(),
                    () {
                      _uploadError = true;
                    }); //returns a cbk function which will be invoked at submit
              }));
    }
    /*
    for (Map im in RuntimeStore()
        .getUser()!
        .imagesDetails) {
      existingImages.add(
          GalleryImage(Image.network(
            'http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/images/users/${im['id']}',
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? (loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes as int))
                      : null,
                ),
              );
            },
            //fit: BoxFit.cover,
          ), () {
            removeImage((p0) => null, im['id'].toString());
          }));
    }
     */
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    birthdayController.text =
        "${_birthday.day}/${_birthday.month}/${_birthday.year}";

    return ModalProgressHUD(
      child: ListView(
        key: Key('scroll'),
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImgGallery(
              filesToUploadCbk: (imgList) {
                _images = imgList;
              },
              onSubmitCbksCbk: (cbkList) {
                _onSubmitCbks = cbkList;
              },
              existingImages: existingImages,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                    color: RuntimeStore().credentialsLogin
                        ? Colors.black
                        : Colors.grey),
                enabled: RuntimeStore().credentialsLogin,
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
                style: TextStyle(
                    color: RuntimeStore().credentialsLogin
                        ? Colors.black
                        : Colors.grey),
                enabled: RuntimeStore().credentialsLogin,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                controller: nameController,
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                    color: RuntimeStore().credentialsLogin
                        ? Colors.black
                        : Colors.grey),
                enabled: RuntimeStore().credentialsLogin,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cognome',
                ),
                controller: surnameController,
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                    color: RuntimeStore().credentialsLogin
                        ? Colors.black
                        : Colors.grey),
                controller: birthdayController,
                readOnly: true,
                enabled: RuntimeStore().credentialsLogin,
                onTap: RuntimeStore().credentialsLogin
                    ? () {
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
                      }
                    : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data di nascita',
                ),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Text(
                "Genere",
                style: TextStyle(
                    color: RuntimeStore().credentialsLogin
                        ? Colors.black
                        : Colors.grey),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: //Row(children: [
                  //Expanded(
                  //child:
                  DropdownButton<Gender>(
                hint: const Text("Scegli il tuo genere"),
                value: _gender,
                onChanged: RuntimeStore().credentialsLogin
                    ? (newValue) {
                        setState(() {
                          _gender = newValue;
                        });
                      }
                    : null,
                items: Gender.values.map((gender) {
                  return DropdownMenuItem(
                    child: Text(gender.toItalianString()),
                    value: gender,
                  );
                }).toList(),
              ) //)
              //  ])
              ),
          RuntimeStore().credentialsLogin
              ? const SizedBox()
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "I dati anagrafici sono ottenuti da Google, se li hai modificati esci e accedi nuovamente per aggiornarli",
                    style: TextStyle(color: Colors.grey),
                  )),
          RuntimeStore().credentialsLogin
              ? ElevatedButton(
                  child: const Text("Modifica"),
                  style: ElevatedButton.styleFrom(primary: Colors.brown),
                  onPressed: () {
                    String email = emailController.text;
                    String name = nameController.text;
                    String surname = surnameController.text;

                    if ((email.isNotEmpty &&
                        name.isNotEmpty &&
                        surname.isNotEmpty &&
                        _gender != null)) {
                      numUploads = 0;

                      setState(() {
                        _isLoading = true;
                      });

                      numUploads++; //for editprofilePost
                      if (_images.isNotEmpty) {
                        numUploads++;
                      }
                      for (Function fun in _onSubmitCbks) {
                        fun();
                      }
                      if (_images.isNotEmpty) {
                        UserHandler.addImages(
                            () {
                              uploadCtr++;
                              if (uploadCtr == numUploads) {
                                onUploadsEnd();
                              }
                            },
                            _images,
                            () {
                              _uploadError = true;
                            });
                      }

                      UserHandler.editInformation(
                          () {
                            uploadCtr++;
                            if (uploadCtr == numUploads) {
                              onUploadsEnd();
                            }
                          },
                          name,
                          surname,
                          _birthday,
                          _gender as Gender,
                          () {
                            _uploadError = true;
                          });

                      String oldEmail = RuntimeStore().getUser()!.email;
                      if (email != oldEmail) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InsertPassword(
                                    description:
                                        "Reinserisci la tua password per modificare l'email",
                                    callback: (String password,
                                        Function(bool, String) updateUi) async {
                                      UserHandler.updateEmail(
                                          email, password, updateUi,
                                          (User newUser) {
                                        //onComplete
                                        RuntimeStore().setUser(newUser);
                                        setState(() {
                                          user = newUser;
                                          init();
                                        });
                                        //updateUi(false, "");
                                        Navigator.pop(context);
                                      }, () {
                                        //onConnectionError
                                        Navigator.restorablePush(
                                            context,
                                            ErrorDialogBuilder
                                                .buildConnectionErrorRoute);
                                      });
                                    })));
                        setState(() {
                          emailController.text = oldEmail;
                        });
                      }
                    } else {
                      setState(() {
                        status = "Incompleto. Compila tutti i campi";
                      });
                    }
                  })
              : const SizedBox(),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.grey,
          ),
          RuntimeStore().credentialsLogin
              ? ElevatedButton(
                  child: const Text("Aggiorna la password"),
                  style: ElevatedButton.styleFrom(primary: Colors.brown),
                  onPressed: () {
                    Navigator.pushNamed(context, "/editpassword");
                  })
              : const SizedBox(),
          ElevatedButton(
              child: const Text("Modifica informazioni locatario"),
              style: ElevatedButton.styleFrom(primary: Colors.brown),
              onPressed: () {
                Navigator.pushNamed(context, "/edittenants");
              }),
          ElevatedButton(
              key: const Key('esci'),
              child: const Text("Esci"),
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                if (!RuntimeStore().credentialsLogin) {
                  try {
                    await GoogleAuthentication.initializeFirebase();
                    await GoogleAuthentication.signOut(context: context);
                  } on Exception {
                    setState(() {
                      _isLoading = false;
                      Navigator.restorablePush(
                          context, ErrorDialogBuilder.buildGenericErrorRoute);
                    });
                  }
                }
                RuntimeStore().getSharedPreferences()?.remove("logged");
                RuntimeStore()
                    .getSharedPreferences()
                    ?.remove("credentialslogin");
                RuntimeStore().matchHandler.stopPeriodicUpdate();
                RuntimeStore().matchHandler.removeLastViewedMatchDate();
                RuntimeStore().cookieJar.deleteAll();
                Navigator.pushReplacementNamed(context, "/loginorsignup");
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    surnameController.dispose();
    birthdayController.dispose();
  }
}

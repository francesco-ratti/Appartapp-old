import 'dart:io';

import 'package:appartapp/classes/connection_exception.dart';
import 'package:appartapp/classes/enum_gender.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/pages/reinsert_password.dart';
import 'package:appartapp/widgets/ImgGallery.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditProfile extends StatefulWidget {
  String urlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/edituser";
  String urlPwdStr="http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/editsensitive";
  String addImagesUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/adduserimage";
  String removeImagesUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/deleteuserimage";
  Color bgColor = Colors.white;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<File> _images = <File>[];
  List<Function> _onSubmitCbks = <Function>[];

  bool _isLoading = false;
  bool _uploadError = false;

  int uploadCtr = 0;
  int numUploads = 0;

  void onUploadsEnd() {
    setState(() {
      _isLoading = false;
    });
    if (_uploadError) {
      _uploadError = false;
      Navigator.restorablePush(
          context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
    }
  }

  void addImages(Function cbk, List<File> files) async {
    var dio = RuntimeStore().dio; //ok
    try {
      var formData = FormData();

      for (final File file in files) {
        MultipartFile mpfile =
            await MultipartFile.fromFile(file.path, filename: "filename.jpg");
        formData.files.add(MapEntry("images", mpfile));
      }

      Response response = await dio.post(
        widget.addImagesUrlStr,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      if (response.statusCode != 200) {
        _uploadError = true;
      }

      cbk();
    } on DioError {
      _uploadError = true;

      cbk();
    }
  }

  void removeImage(Function cbk, String id) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        widget.removeImagesUrlStr,
        data: {"id": id},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        _uploadError = true;
      }

      cbk();
    } on DioError {
      _uploadError = true;
      cbk();
    }
  }

  void doUpdate(Function cbk, String name, String surname, DateTime birthday,
      Gender gender) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        widget.urlStr,
        data: {
          "name": name,
          "surname": surname,
          "birthday": birthday.millisecondsSinceEpoch.toString(),
          "gender": gender.toShortString(),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        _uploadError = true;
      }
      cbk();
    } on DioError {
      _uploadError = true;
      cbk();
    }
  }

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthdayController = TextEditingController();

  String status = "";

  User? user = RuntimeStore().getUser();

  late DateTime _birthday = new DateTime.now();

  Gender? _gender;

  List<GalleryImage> existingImages = [];

  @override
  void initState() {
    super.initState();

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
                removeImage(() {
                  uploadCtr++;
                  if (uploadCtr == numUploads) {
                    onUploadsEnd();
                  }
                },
                    im['id']
                        .toString()); //returns a cbk function which will be invoked at submit
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
  Widget build(BuildContext context) {
    birthdayController.text =
        "${_birthday.day}/${_birthday.month}/${_birthday.year}";

    return ModalProgressHUD(
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
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
            padding: EdgeInsets.all(8.0),
            child: TextField(
              enabled: RuntimeStore().credentialsLogin,
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
              enabled: RuntimeStore().credentialsLogin,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
              controller: nameController,
            )),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              enabled: RuntimeStore().credentialsLogin,
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
                if (RuntimeStore().credentialsLogin) {
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
                    onChanged: RuntimeStore().credentialsLogin ? (newValue) {
                      setState(() {
                        _gender = newValue;
                      });
                    } : null,
                    items: Gender.values.map((gender) {
                      return DropdownMenuItem(
                        child: Text(gender.toItalianString()),
                        value: gender,
                      );
                    }).toList(),
                  ))
            ])),
        RuntimeStore().credentialsLogin ? ElevatedButton(
            child: Text("Modifica"),
            style: ElevatedButton.styleFrom(primary: Colors.brown),
            onPressed: () {
              String email = emailController.text;
              String name = nameController.text;
              String surname = surnameController.text;

              if ((email.length > 0 &&
                  name.length > 0 &&
                  surname.length > 0 &&
                  _gender != null)) {
                      numUploads = 0;

                      setState(() {
                        _isLoading = true;
                      });

                      numUploads++; //for editapartmentPost
                      if (_images.isNotEmpty) {
                        numUploads++;
                      }
                      for (Function fun in _onSubmitCbks) {
                        fun();
                      }
                      if (_images.isNotEmpty) {
                        addImages(() {
                          uploadCtr++;
                          if (uploadCtr == numUploads) {
                            onUploadsEnd();
                          }
                        }, _images);
                      }

                      doUpdate(() {
                        uploadCtr++;
                        if (uploadCtr == numUploads) {
                          onUploadsEnd();
                        }
                      }, name, surname, _birthday, _gender as Gender);

                      if (email != RuntimeStore().getUser()?.email) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InsertPassword(
                                        (String password,
                                            Function(String) updateUi) async {
                                      var dio = RuntimeStore().dio; //ok
                                      try {
                                        Response response = await dio.post(
                                          widget.urlPwdStr,
                                          data: {
                                            "newemail": email,
                                            "password": password,
                                          },
                                          options: Options(
                                            contentType: Headers
                                                .formUrlEncodedContentType,
                                            headers: {
                                              "Content-Type":
                                                  "application/x-www-form-urlencoded"
                                            },
                                          ),
                                  );

                                  if (response.statusCode != 200) {
                                          updateUi("Failure");
                                        } else {
                                          updateUi("Updated");
                                          Map responseMap = response.data;
                                          RuntimeStore().setUser(
                                              User.fromMap(responseMap));
                                          Navigator.pop(context);
                                        }
                                      } on DioError catch (e) {
                                  if (e.type ==
                                      DioErrorType.connectTimeout ||
                                      e.type ==
                                          DioErrorType.receiveTimeout ||
                                      e.type == DioErrorType.other ||
                                      e.type == DioErrorType.sendTimeout ||
                                      e.type == DioErrorType.cancel) {
                                    throw ConnectionException();
                                  }
                                  if (e.response?.statusCode != 200) {
                                    updateUi("Failure");
                                  }
                                }
                              })));
                }

              } else {
                setState(() {
                  status = "Incompleto. Compila tutti i campi";
                });
              }
            }) : const SizedBox(),
        const Divider(
          height: 20,
          thickness: 1,
          indent: 20,
          endIndent: 20,
          color: Colors.grey,
        ), RuntimeStore().credentialsLogin ? ElevatedButton(
            child: Text("Aggiorna la password"),
            style: ElevatedButton.styleFrom(primary: Colors.brown),
            onPressed: () {
              Navigator.pushNamed(context, "/editpassword");
            }) : const SizedBox(),
        ElevatedButton(
            child: Text("Modifica informazioni locatario"),
            style: ElevatedButton.styleFrom(primary: Colors.brown),
            onPressed: () {
              Navigator.pushNamed(context, "/edittenants");
            }),
        ElevatedButton(
            child: Text("Esci"),
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              RuntimeStore().getSharedPreferences()?.remove("logged");
              RuntimeStore().getSharedPreferences()?.remove("credentialslogin");
              RuntimeStore().matchHandler.stopPeriodicUpdate();
                RuntimeStore().cookieJar.deleteAll();
                Navigator.pushReplacementNamed(context, "/loginorsignup");
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

import 'dart:io';

import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/exceptions/unauthorized_exception.dart';
import 'package:appartapp/widgets/ImgGallery.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddApartment extends StatefulWidget {
  @override
  State<AddApartment> createState() => _AddApartment();

  final String urlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/createapartment";
}

class _AddApartment extends State<AddApartment> {
  void doCreateApartmentPost(
      Function(String) updateUi,
      String listingTitle,
      String description,
      String additionalExpenseDetail,
      int price,
      String address,
      List<File> files) async {
    var dio = Dio();
    try {
      var formData = FormData();

      Credentials? credentials = RuntimeStore().getCredentials();
      if (credentials != null) {
        formData.fields.add(MapEntry("email", credentials.email));
        formData.fields.add(MapEntry("password", credentials.password));

        formData.fields.add(MapEntry("listingtitle", listingTitle));
        formData.fields.add(MapEntry("description", description));
        formData.fields
            .add(MapEntry("additionalexpensedetail", additionalExpenseDetail));
        formData.fields.add(MapEntry("price", price.toString()));
        formData.fields.add(MapEntry("address", address));

        for (final File file in files) {
          MultipartFile mpfile =
          await MultipartFile.fromFile(file.path, filename: "filename.jpg");
          formData.files.add(MapEntry("images", mpfile));
        }

        Response response = await dio.post(
          widget.urlStr,
          data: formData,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {"Content-Type": "multipart/form-data"},
          ),
        );

        if (response.statusCode != 200) {
          if (response.statusCode == 401) {
            updateUi("Non autorizzato");
            throw new UnauthorizedException();
          } else {
            updateUi("Errore interno");
            return;
          }
        } else {
          print("added");
          Navigator.pop(context);
        }
      } else
        throw new UnauthorizedException();
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateUi("Non autorizzato");
        throw new UnauthorizedException();
      } else {
        updateUi("Errore interno");
      }
    }
  }



  String status = "";

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _aedController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  static const Color colorTheme = Colors.black;

  bool uploading = false;
  List<File> _toUpload = [];

  @override
  Widget build(BuildContext context) {
    //final User user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                header(),
                ImgGallery(callback: (imageList) {
                  _toUpload=imageList;
                },),
                title(),
                desc(),
                address(),
                price(),
                sendButton(),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(child: const BackButton()),
          Center(
            child: Text(
              'Il tuo appartamento',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget title() {
    return Container(
      child: TextField(
        controller: _titleController,
        cursorColor: colorTheme,
        decoration: InputDecoration(
          hintText: 'Monolocale Milano',
          hintStyle: TextStyle(color: Colors.black),
          labelText: 'Titolo',
          labelStyle: const TextStyle(color: colorTheme),
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget desc() {
    return Container(
      child: TextField(
        controller: _descController,
        cursorColor: colorTheme,
        decoration: InputDecoration(
          hintText: 'Monolocale luminoso con terrazza al quinto piano di...',
          hintStyle: TextStyle(color: Colors.black),
          labelText: 'Descrizione',
          labelStyle: const TextStyle(color: colorTheme),
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget address() {
    return Container(
      child: TextField(
        controller: _addressController,
        cursorColor: colorTheme,
        decoration: InputDecoration(
          hintText: 'Via Roma, 22',
          hintStyle: TextStyle(color: Colors.black),
          labelText: 'Indirizzo',
          labelStyle: const TextStyle(color: colorTheme),
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget price() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: TextField(
            controller: _priceController,
            cursorColor: colorTheme,
            decoration: InputDecoration(
              hintText: '350',
              hintStyle: TextStyle(color: Colors.black),
              labelText: 'Prezzo',
              labelStyle: const TextStyle(color: colorTheme),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          child: TextField(
            controller: _aedController,
            cursorColor: colorTheme,
            decoration: InputDecoration(
              hintText: 'dettagli',
              hintStyle: TextStyle(color: Colors.black),
              labelText: 'Spese aggiuntive',
              labelStyle: const TextStyle(color: colorTheme),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget sendButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        child: ElevatedButton(
          onPressed: !uploading
              ? () {
            if (isReady()) {
              setState(() {
                uploading = true;
                status = "Caricamento in corso...";
              });
              doCreateApartmentPost((String toWrite) {
                setState(() {
                  status = toWrite;
                  print(status);
                });
              },
                  _titleController.text,
                  _descController.text,
                  _aedController.text,
                  int.parse(_priceController.text),
                  _addressController.text,
                  _toUpload);
            }
          }
              : null,
          style: ElevatedButton.styleFrom(primary: Colors.black87),
          child: Text(
            'Pubblica'.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  bool isReady() {
    if (_titleController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _aedController.text.isNotEmpty &&
        _toUpload != null &&
        _toUpload.length > 0)
      return true;
    else
      return false;
  }
}
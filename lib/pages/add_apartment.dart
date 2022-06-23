import 'dart:io';

import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/exceptions/unauthorized_exception.dart';
import 'package:appartapp/widgets/ImgGallery.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddApartment extends StatefulWidget {
  final Apartment? toEdit;
  final Function? callback;

  const AddApartment({Key? key, this.toEdit, this.callback}) : super(key: key);

  @override
  State<AddApartment> createState() => _AddApartment(toEdit);

  final String urlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/createapartment";

  final String editApartmentUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/editapartment";

  final String removeImagesUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/deleteapartmentimage";


  final String addImagesUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/addapartmentimage";
}

class _AddApartment extends State<AddApartment> {

  Apartment? toEdit;

  _AddApartment(this.toEdit);

  void doCreateApartmentPost(
      Function(String) updateUi,
      String listingTitle,
      String description,
      String additionalExpenseDetail,
      int price,
      String address,
      List<File> files) async {
    var dio = RuntimeStore().dio;
    try {
      var formData = FormData();


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
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateUi("Non autorizzato");
        throw new UnauthorizedException();
      } else {
        updateUi("Errore interno");
      }
    }
  }

  void removeImage(Function(String) updateUi, String imageId, String apartmentId) async {
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        widget.removeImagesUrlStr,
        data: {
          "imageid": imageId,
          "apartmentid": apartmentId
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
      }
    } on DioError catch (e) {
      if (e.response?.statusCode != 200) {
        updateUi("Failure");
      }
    }
  }

  void doEditApartmentPost(
      Function(String) updateUi,
      int id,
      String listingTitle,
      String description,
      String additionalExpenseDetail,
      int price,
      String address) async {
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        widget.editApartmentUrlStr,
        data: {
          "id": id,
          "listingtitle": listingTitle,
          "description": description,
          "additionalexpensedetail": additionalExpenseDetail,
          "price": price.toString(),
          "address": address
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
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
        print("edited");
        updateUi("edited");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateUi("Non autorizzato");
        throw new UnauthorizedException();
      } else {
        updateUi("Errore interno");
      }
    }
  }

  void addImages(
      Function(String) updateUi,
      int id,
      List<File> files) async {
    var dio = RuntimeStore().dio;
    try {
      var formData = FormData();

      formData.fields.add(MapEntry("id", id.toString()));

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
        if (response.statusCode == 401) {
          updateUi("Non autorizzato");
          throw new UnauthorizedException();
        } else {
          updateUi("Errore interno");
          return;
        }
      } else {
        print("added");
        updateUi("added");
      }
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

  List<GalleryImage> existingImages=[];
  List<Function> _onSubmitCbks=<Function>[];
  int _totalImages=0;

  int uploadCtr=0;
  int numUploads=0;
  void onUploadsEnd () {
    if (widget.callback!=null)
      widget.callback!();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (toEdit!=null) {
      _titleController.text=toEdit!.listingTitle;
      _descController.text=toEdit!.description;
      _priceController.text=toEdit!.price.toString();
      _aedController.text=toEdit!.additionalExpenseDetail;
      _addressController.text=toEdit!.address;

      for (int i=0; i<toEdit!.imagesDetails.length; i++) {
        Map im=toEdit!.imagesDetails[i];
        existingImages.add(
            GalleryImage(
                toEdit!.images[i],
                    () => () {
                  numUploads++;
                  removeImage((p0) {
                    uploadCtr++;
                    if (uploadCtr==numUploads) {
                      onUploadsEnd();
                    }
                  }, im['id'].toString(), toEdit!.id.toString()); //returns a cbk function which will be invoked at submit
                })
        );
      }
    }
  }

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
                ImgGallery(
                  filesToUploadCbk: (imageList) {
                    _toUpload=imageList;
                  },
                  onSubmitCbksCbk: (cbkList) {
                    _onSubmitCbks=cbkList;
                  },
                  totalImagesCbk: (int totalImages) {
                    _totalImages=totalImages;
                  }, existingImages: existingImages,),
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
              if (toEdit==null) {
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
              } else {
                numUploads++; //for editapartmentPost
                if (_toUpload.isNotEmpty)
                  numUploads++;
                for (Function fun in _onSubmitCbks) {
                  fun();
                }
                if (_toUpload.isNotEmpty) {
                  addImages((p0) {
                    uploadCtr++;
                    if (uploadCtr == numUploads) {
                      onUploadsEnd();
                    }
                  }, toEdit!.id, _toUpload);
                }
                doEditApartmentPost((String toWrite) {
                  uploadCtr++;
                  if (uploadCtr==numUploads) {
                    onUploadsEnd();
                  }
                },
                  toEdit!.id,
                  _titleController.text,
                  _descController.text,
                  _aedController.text,
                  int.parse(_priceController.text),
                  _addressController.text,
                );
              }
            }
          }
              : null,
          style: ElevatedButton.styleFrom(primary: Colors.black87),
          child: Text(
            toEdit==null ? 'AGGIUNGI' : 'MODIFICA',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  bool isReady() {
    return (_titleController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _aedController.text.isNotEmpty && _totalImages>0);
  }
}
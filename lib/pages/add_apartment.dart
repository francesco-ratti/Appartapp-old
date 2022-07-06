import 'dart:io';

import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/ImgGallery.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/error_dialog_builder.dart';

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

  bool _isLoading = false;
  bool _uploadError = false;

  _AddApartment(this.toEdit);

  void doCreateApartmentPost(
      Function cbk,
      String listingTitle,
      String description,
      String additionalExpenseDetail,
      int price,
      String address,
      List<File> files) async {
    var dio = RuntimeStore().dio; //ok
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

      if (response.statusCode != 200)
        _uploadError = true;
      else {
        cbk();
      }
    } on DioError {
      _uploadError = true;
    }
  }

  void removeImage(Function cbk, String imageId, String apartmentId) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        widget.removeImagesUrlStr,
        data: {"imageid": imageId, "apartmentid": apartmentId},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200)
        _uploadError = true;
      else {
        cbk();
      }
    } on DioError {
      _uploadError = true;
    }
  }

  void doEditApartmentPost(
      Function() cbk,
      int id,
      String listingTitle,
      String description,
      String additionalExpenseDetail,
      int price,
      String address) async {
    var dio = RuntimeStore().dio; //ok
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

      if (response.statusCode != 200)
        _uploadError = true;
      else {
        cbk();
      }
    } on DioError {
      _uploadError = true;
    }
  }

  void addImages(Function cbk, int id, List<File> files) async {
    var dio = RuntimeStore().dio; //ok
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

      if (response.statusCode != 200)
        _uploadError = true;
      else {
        cbk();
      }
    } on DioError {
      _uploadError = true;
    }
  }

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
    if (_uploadError) {
      Navigator.restorablePush(
          context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
    } else {
      setState(() {
        _isLoading = false;
      });
      if (widget.callback != null) widget.callback!();
    }
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
    return ModalProgressHUD(
        inAsyncCall: _isLoading,
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: SafeArea(
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
                  ],
                ),
              ),
            ),
          ),
        ));
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
          onPressed: !_isLoading
              ? () {
                  if (isReady()) {
                    numUploads = 0;

                    setState(() {
                      _isLoading = true;
                    });
                    if (toEdit == null) {
                      doCreateApartmentPost(
                          () {},
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
                doEditApartmentPost(
                        () {
                          uploadCtr++;
                          if (uploadCtr == numUploads) {
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
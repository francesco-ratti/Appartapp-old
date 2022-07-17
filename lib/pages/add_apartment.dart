import 'dart:io';

import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/model/apartment_handler.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:appartapp/widgets/img_gallery.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddApartment extends StatefulWidget {
  final Apartment? toEdit;
  final Function? callback;

  const AddApartment({Key? key, this.toEdit, this.callback}) : super(key: key);

  @override
  State<AddApartment> createState() => _AddApartment(toEdit);
}

class _AddApartment extends State<AddApartment> {
  Apartment? toEdit;

  bool _isLoading = false;
  bool _uploadError = false;

  _AddApartment(this.toEdit);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _aedController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  static const Color colorTheme = Colors.black;

  bool uploading = false;
  List<File> _toUpload = [];

  List<GalleryImage> existingImages = [];
  List<Function> _onSubmitCbks = <Function>[];
  int _totalImages = 0;

  String status = "";

  int uploadCtr = 0;
  int numUploads = 0;

  void cbkExecutor() async {
    if (widget.callback != null) {
      await widget.callback!();
    }
    for (Function(bool) fun in RuntimeStore().apartmentAddedCbk) {
      await fun(true);
    }
    Navigator.pop(context);
  }

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
    } else {
      cbkExecutor();
    }
  }

  @override
  void initState() {
    super.initState();
    if (toEdit != null) {
      _titleController.text = toEdit!.listingTitle;
      _descController.text = toEdit!.description;
      _priceController.text = toEdit!.price.toString();
      _aedController.text = toEdit!.additionalExpenseDetail;
      _addressController.text = toEdit!.address;

      for (int i = 0; i < toEdit!.imagesDetails.length; i++) {
        Map im = toEdit!.imagesDetails[i];
        existingImages.add(GalleryImage(
            toEdit!.images[i],
            () => () {
                  numUploads++;
                  ApartmentHandler.removeImage(
                      () {
                        uploadCtr++;
                        if (uploadCtr == numUploads) {
                          onUploadsEnd();
                        }
                      },
                      im['id'].toString(),
                      toEdit!.id.toString(),
                      () {
                        _uploadError = true;
                      }); //returns a cbk function which will be invoked at submit
                }));
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
            appBar: AppBar(
              title: const Text("Il tuo appartamento"),
              backgroundColor: Colors.brown,
            ),
            body: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    //header(),
                    ImgGallery(
                      filesToUploadCbk: (imageList) {
                        _toUpload = imageList;
                      },
                      onSubmitCbksCbk: (cbkList) {
                        _onSubmitCbks = cbkList;
                      },
                      totalImagesCbk: (int totalImages) {
                        _totalImages = totalImages;
                      },
                      existingImages: existingImages,
                    ),
                    title(),
                    desc(),
                    address(),
                    price(),
                    statusMessage(),
                    sendButton(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget header() {
    return Row(
      children: const <Widget>[
        BackButton(),
        Center(
          child: Text(
            'Il tuo appartamento',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget title() {
    return TextField(
      controller: _titleController,
      cursorColor: colorTheme,
      decoration: const InputDecoration(
        hintText: 'Monolocale Milano',
        hintStyle: TextStyle(color: Colors.black),
        labelText: 'Titolo',
        labelStyle: TextStyle(color: colorTheme),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget desc() {
    return TextField(
      controller: _descController,
      cursorColor: colorTheme,
      decoration: const InputDecoration(
        hintText: 'Monolocale luminoso con terrazza al quinto piano di...',
        hintStyle: TextStyle(color: Colors.black),
        labelText: 'Descrizione',
        labelStyle: TextStyle(color: colorTheme),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget address() {
    return TextField(
      controller: _addressController,
      cursorColor: colorTheme,
      decoration: const InputDecoration(
        hintText: 'Via Roma, 22',
        hintStyle: TextStyle(color: Colors.black),
        labelText: 'Indirizzo',
        labelStyle: TextStyle(color: colorTheme),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget price() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        TextField(
          controller: _priceController,
          cursorColor: colorTheme,
          decoration: const InputDecoration(
            hintText: '350',
            hintStyle: TextStyle(color: Colors.black),
            labelText: 'Prezzo',
            labelStyle: TextStyle(color: colorTheme),
          ),
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
        ),
        TextField(
          controller: _aedController,
          cursorColor: colorTheme,
          decoration: const InputDecoration(
            hintText: 'dettagli',
            hintStyle: TextStyle(color: Colors.black),
            labelText: 'Spese aggiuntive',
            labelStyle: TextStyle(color: colorTheme),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget sendButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        onPressed: !_isLoading
            ? () {
                if (isReady()) {
                  setState(() {
                    status = "";
                  });
                  numUploads = 0;

                  setState(() {
                    _isLoading = true;
                  });
                  if (toEdit == null) {
                    ApartmentHandler.createApartment(
                        onUploadsEnd,
                        _titleController.text,
                        _descController.text,
                        _aedController.text,
                        int.parse(_priceController.text),
                        _addressController.text,
                        _toUpload, () {
                      _uploadError = true;
                    });
                  } else {
                    numUploads++; //for editapartmentPost
                    if (_toUpload.isNotEmpty) numUploads++;
                    for (Function fun in _onSubmitCbks) {
                      fun();
                    }
                    if (_toUpload.isNotEmpty) {
                      ApartmentHandler.addImages(
                          () {
                            uploadCtr++;
                            if (uploadCtr == numUploads) {
                              onUploadsEnd();
                            }
                          },
                          toEdit!.id,
                          _toUpload,
                          () {
                            _uploadError = true;
                          });
                    }
                    ApartmentHandler.editApartment(
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
                        () {
                          _uploadError = true;
                        });
                  }
                } else {
                  setState(() {
                    status =
                        "Incompleto. Compila tutti i campi e aggiungi almeno una foto";
                  });
                }
              }
            : null,
        style: ElevatedButton.styleFrom(primary: Colors.black87),
        child: Text(
          toEdit == null ? 'AGGIUNGI' : 'MODIFICA',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  bool isReady() {
    return (_titleController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _aedController.text.isNotEmpty &&
        _totalImages > 0);
  }

  Widget statusMessage() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          status,
          style: const TextStyle(fontSize: 20),
        ));
  }
}

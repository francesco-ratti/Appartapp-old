import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddApartment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddApartment();
}

class _AddApartment extends State<AddApartment> {
  List<CroppedFile> _images = [];
  List<Widget> imageSliders = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _aedController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  static const Color colorTheme = Colors.black;

  Future<void> getImage(ImgSource source) async {
    final PickedFile image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ),
    );

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 85,
      maxHeight: 1920,
      maxWidth: 1920,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        /// this settings is required for Web
        /*WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: Boundary(
            width: 520,
            height: 520,
          ),
          viewPort: ViewPort(
              width: 480,
              height: 480,
              type: 'circle'
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        )*/
      ],
    );

    if (croppedFile!=null) {
      _images.add(croppedFile);
      croppedFile.readAsBytes().then((byteStream) {
        setState(() {
          imageSliders.add(Container(
            //child: Image.file(File(croppedFile.path)),
            child: Image.memory(byteStream),
            //child: Image.memory(croppedFile.readAsBytesSync()),
            constraints: const BoxConstraints(maxWidth: 200),
          ));
        });
      });
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
                addPhotos(),
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

  Widget addPhotos() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: ElevatedButton(
                  onPressed: () => getImage(ImgSource.Both),
                  style: ElevatedButton.styleFrom(primary: Colors.black38),
                  child: Text(
                    'Aggiungi una foto'.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              if (_images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          initialPage: 2,
                          autoPlay: true,
                        ),
                        items: imageSliders,
                      )),

                  // Container(
                  //   child: Image.file(File(_image!.path)),
                  //   constraints: const BoxConstraints(maxWidth: 200),
                  //),
                )
              else
                Container(),
            ],
          ),
        ),
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
              hintText: 'si/no',
              hintStyle: TextStyle(color: Colors.black),
              labelText: 'Spese Incluse',
              labelStyle: const TextStyle(color: colorTheme),
            ),
            keyboardType: TextInputType.number,
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
          onPressed: () => isReady() ? publishApartment() : null,
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
        _images != null)
      return true;
    else
      return false;
  }

  // void publishApartment(User user) {
  //   final ItemModel newItem = ItemModel(
  //       imagePath: _image,
  //       name: _titleController.text,
  //       description: _descController.text,
  //       price: _priceController.text,
  //       shippingFees: _fdpController.text,
  //       state: _stateController.text,
  //       author: user.name ?? 'Jack Leborgne');
  //   it.insert(0, newItem);
  //   Navigator.pop(context);
  // }

  void publishApartment() {
    //TODO
    Navigator.pop(context);
  }
}

import 'dart:ui';
import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/exceptions/unauthorized_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddApartment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddApartment();

  final String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/createapartment";
}

class _AddApartment extends State<AddApartment> {

  void doCreateApartmentPost(Function(String) updateUi, String listingTitle, String description, String additionalExpenseDetail, int price, String address, List<CroppedFile> files) async {
    var dio = Dio();
    try {
      var formData = FormData();

      Credentials? credentials=RuntimeStore().getCredentials();
      if (credentials!=null) {
        formData.fields.add(MapEntry("email", credentials.email));
        formData.fields.add(MapEntry("password", credentials.password));

        formData.fields.add(MapEntry("listingtitle", listingTitle));
        formData.fields.add(MapEntry("description", description));
        formData.fields.add(MapEntry("additionalexpensedetail", additionalExpenseDetail));
        formData.fields.add(MapEntry("price", price.toString()));
        formData.fields.add(MapEntry("address", address));

        for (final CroppedFile file in files) {
          MultipartFile mpfile = await MultipartFile.fromFile(
              file.path, filename: "image.jpg");
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
          }
          else {
            updateUi("Errore interno");
            return;
          }
        }
        else {
//          print("added");
          Navigator.pop(context);
        }
      } else throw new UnauthorizedException();
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateUi("Non autorizzato");
        throw new UnauthorizedException();
      }
      else {
        updateUi("Errore interno");
      }
    }
  }


  List<CroppedFile> _images = [];
  List<Widget> imageSliders = [];

  String status="";

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

  bool uploading=false;

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
          onPressed: !uploading ? () {
            if (isReady()) {
              setState(() {
                uploading = true;
                status = "Caricamento in corso...";
              });
              doCreateApartmentPost(
                      (String toWrite) {
                    setState(() {
                      status = toWrite;
                    });
                  },
                  _titleController.text,
                  _descController.text,
                  _aedController.text,
                  int.parse(_priceController.text),
                  _addressController.text,
                  _images
              );
            }
          }: null,
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
        _images != null && _images.length>0)
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
}

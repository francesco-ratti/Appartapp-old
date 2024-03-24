import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
/*
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
*/

class ImgGallery extends StatefulWidget {
  final Function(List<File>)
  filesToUploadCbk; //will be called ONLY when new images are added or new images (ones which have been added during current "session", the ones which have to be uploaded) are removed
  final Function?
  onSubmitCbksCbk; //will be called when online images are removed. Updates OnSubmitCallbacks list, which has to be called on submit.
  final Function? totalImagesCbk;

  final List<GalleryImage>? existingImages;

  const ImgGallery(
      {Key? key,
        required this.filesToUploadCbk,
        this.onSubmitCbksCbk,
        this.totalImagesCbk,
        //this.existingImages = const []}
        this.existingImages})
      : super(key: key);

  @override
  _ImgGalleryState createState() => _ImgGalleryState(
    imagesToShow: (existingImages == null
        ? <GalleryImage>[]
        : existingImages as List<GalleryImage>),
  );
}

class GalleryImage {
  Image image;
  Function onDelete;

  GalleryImage(this.image, this.onDelete);
}

class _ImgGalleryState extends State<ImgGallery> {
  List<GalleryImage> imagesToShow = [];
  final List<File> _toUpload = [];
  List<Function> onSubmitCbks = [];
  int currentOpenedPage = 0;
  int currentSmallImage = 0;
  final ImagePicker _picker = ImagePicker();

  // final TextEditingController maxWidthController = TextEditingController();
  // final TextEditingController maxHeightController = TextEditingController();
  // final TextEditingController qualityController = TextEditingController();

  // Future<void> _displayPickImageDialog(
  //     BuildContext context, OnPickImageCallback onPick) async {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Add optional parameters'),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               TextField(
  //                 controller: maxWidthController,
  //                 keyboardType:
  //                 const TextInputType.numberWithOptions(decimal: true),
  //                 decoration: const InputDecoration(
  //                     hintText: 'Enter maxWidth if desired'),
  //               ),
  //               TextField(
  //                 controller: maxHeightController,
  //                 keyboardType:
  //                 const TextInputType.numberWithOptions(decimal: true),
  //                 decoration: const InputDecoration(
  //                     hintText: 'Enter maxHeight if desired'),
  //               ),
  //               TextField(
  //                 controller: qualityController,
  //                 keyboardType: TextInputType.number,
  //                 decoration: const InputDecoration(
  //                     hintText: 'Enter quality if desired'),
  //               ),
  //             ],
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('CANCEL'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //                 child: const Text('PICK'),
  //                 onPressed: () {
  //                   final double? width = maxWidthController.text.isNotEmpty
  //                       ? double.parse(maxWidthController.text)
  //                       : null;
  //                   final double? height = maxHeightController.text.isNotEmpty
  //                       ? double.parse(maxHeightController.text)
  //                       : null;
  //                   final int? quality = qualityController.text.isNotEmpty
  //                       ? int.parse(qualityController.text)
  //                       : null;
  //                   onPick(width, height, quality);
  //                   Navigator.of(context).pop();
  //                 }),
  //           ],
  //         );
  //       });
  // }

  _ImgGalleryState({required this.imagesToShow});

  Future<void> getImage(source) async {
    XFile? image;
/*    await _displayPickImageDialog(context,
            (double? maxWidth, double? maxHeight, int? quality) async {
          try {*/
    image = await _picker.pickImage(
      source: source,
      maxWidth: null,
      maxHeight: null,
      imageQuality: null,
    );
/*            setState(() {
              _setImageFileListFromFile(image);
            });*//*
          } catch (e) {
            //TODO
*//*            setState(() {
              _pickImageError = e;
            });*//*
          }
        });*/

    if (image==null) {
      return;
    } else {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image!.path,
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
              toolbarTitle: 'Ritaglia la foto',
              toolbarColor: Colors.brown,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Ritaglia la foto',
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

      if (croppedFile == null) {
        return;
      }
      croppedFile.readAsBytes().then((byteStream) {
        File file = File(croppedFile.path);
        _toUpload.add(file);
        widget.filesToUploadCbk(_toUpload);
        setState(() {
          imagesToShow.add(GalleryImage(Image.file(file), () {
            _toUpload.remove(file);
            return null;
          }));
          if (widget.totalImagesCbk != null) {
            widget.totalImagesCbk!(imagesToShow.length);
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.totalImagesCbk != null) {
      widget.totalImagesCbk!(imagesToShow.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = [];
    for (var element in imagesToShow) {
      imageSliders.add(Container(
        //child: Image.file(File(croppedFile.path)),
        child: element.image,
        //child: Image.memory(croppedFile.readAsBytesSync()),
        //constraints: const BoxConstraints(maxWidth: 200),
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (imageSliders.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      currentOpenedPage = currentSmallImage;

                      Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => DismissiblePage(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CarouselSlider(
                                    options: CarouselOptions(
                                      onPageChanged: (pageN,
                                          CarouselPageChangedReason reason) {
                                        currentOpenedPage = pageN;
                                      },
                                      aspectRatio: 1,
                                      enableInfiniteScroll: false,
                                      initialPage: currentSmallImage,
                                      viewportFraction: 1,
                                    ),
                                    items: imageSliders),
                                Positioned(
                                    bottom: 30,
                                    right: 30,
                                    height: 70,
                                    width: 70,
                                    child: FloatingActionButton(
                                      child: const Icon(Icons.remove, color: Colors.white),
                                      backgroundColor: Colors.brown,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          Function? res =
                                          imagesToShow[currentOpenedPage]
                                              .onDelete();
                                          if (res != null &&
                                              widget.onSubmitCbksCbk != null) {
                                            onSubmitCbks.add(res);
                                            widget
                                                .onSubmitCbksCbk!(onSubmitCbks);
                                          }
                                          imagesToShow
                                              .removeAt(currentOpenedPage);
                                          if (widget.totalImagesCbk != null) {
                                            widget.totalImagesCbk!(
                                                imagesToShow.length);
                                          }
                                        });
                                      },
                                    )),
                              ],
                            ),
                          ),
                          onDismissed: () => Navigator.of(context).pop(),
                          startingOpacity: 0.8,
                          dragSensitivity: 1,
                        ),
                      ));
                    },
                    child: CarouselSlider(
                      options: CarouselOptions(
                        onPageChanged:
                            (pageN, CarouselPageChangedReason reason) {
                          currentSmallImage = pageN;
                        },
                        aspectRatio: 2,
                        enableInfiniteScroll: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 2),
                        viewportFraction: 0.8,
                      ),
                      items: imageSliders,
                    ),
                  ),
                )
              else
                Container(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        child: const Icon(Icons.camera, color: Colors.white),
                        backgroundColor: Colors.brown,
                        onPressed: () => getImage(ImageSource.camera),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        child: const Icon(Icons.browse_gallery, color: Colors.white),
                        backgroundColor: Colors.brown,
                        onPressed: () => getImage(ImageSource.gallery),
                      ),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}

//ImageSource.gallery
/*
typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
*/

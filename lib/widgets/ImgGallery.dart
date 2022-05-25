import 'package:flutter/material.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImgGallery extends StatefulWidget {

  final Function(List<CroppedFile>) callback;

  const ImgGallery({Key? key, required this.callback}) : super(key: key);

  @override
  _ImgGalleryState createState() => _ImgGalleryState();
}

class _ImgGalleryState extends State<ImgGallery> {
  List<CroppedFile> _images = [];
  List<Widget> imageSliders = [];

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

    if (croppedFile != null) {
      _images.add(croppedFile);
      widget.callback(_images);
      croppedFile.readAsBytes().then((byteStream) {
        setState(() {
          imageSliders.add(Container(
            //child: Image.file(File(croppedFile.path)),
            child: Image.memory(byteStream),
            //child: Image.memory(croppedFile.readAsBytesSync()),
            //constraints: const BoxConstraints(maxWidth: 200),
          ));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    //color: Colors.amber,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, __, ___) => DismissiblePage(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: CarouselSlider(
                                    options: CarouselOptions(
                                      aspectRatio: 1,
                                      enableInfiniteScroll: false,
                                      initialPage: 0,
                                      viewportFraction: 1,
                                    ),
                                    items: imageSliders),
                              ),
                              onDismissed: () => Navigator.of(context).pop(),
                              startingOpacity: 0.8,
                              dragSensitivity: 1,
                            ),
                          ));
                        },
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2,
                            enableInfiniteScroll: false,
                            autoPlay: true,
                            viewportFraction: 0.8,
                          ),
                          items: imageSliders,
                        ),
                      )),
                )
              else
                Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  child: const Icon(Icons.add_a_photo),
                  backgroundColor: Colors.brown,
                  onPressed: () => getImage(ImgSource.Both),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:appartapp/entities/user.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Apartment {
  static const String urlStrMarkAsIgnored = "";
  static const String urlStrMarkAsLiked = "";

  final int id;
  final String listingTitle;
  final String description;
  final int price;
  final String address;
  final String additionalExpenseDetail;

  late List imagesDetails;
  final List<Image> images;

  User? owner;

  Apartment(
      {required this.id,
      required this.listingTitle,
      required this.description,
      required this.price,
      required this.address,
      required this.additionalExpenseDetail,
      required this.imagesDetails,
      required this.images,
      this.owner});

  static List<Image> fromImagesDetailsToImages(List imagesDetails) {
    List<Image> images = [];
    for (final Map im in imagesDetails) {
      images.add(Image.network(
        'http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/images/apartments/${im['id']}',
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
        fit: BoxFit.cover,
      ));
    }
    return images;
  }

  static List<Image> fromImagesUriToImages(List<String> imagesUri) {
    List<Image> images = [];
    for (final String uri in imagesUri) {
      images.add(Image.asset(uri));
    }
    return images;
  }

  Apartment.fromMap(Map map)
      : this.id = map['id'],
        this.listingTitle = map["listingTitle"],
        this.description = map['description'],
        this.price = map['price'],
        this.address = map['address'],
        this.additionalExpenseDetail = map['additionalExpenseDetail'],
        this.imagesDetails = map['images'],
        this.images = fromImagesDetailsToImages(map['images']),
        this.owner = map['owner'] == null ? null : User.fromMap(map['owner']);

  Apartment.withLocalImages(this.id, this.listingTitle, this.description,
      this.price, this.address, this.additionalExpenseDetail, imagesUri)
      : this.images = fromImagesUriToImages(imagesUri);

  void _performRequest(BuildContext context, String urlStr) async {
    var dio = RuntimeStore().dio; //ok

    try {
      Response response = await dio.post(
        urlStr,
        data: {"apartmentid": this.id},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        Navigator.restorablePush(
            context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
      }
    } on DioError {
      Navigator.restorablePush(
          context, ErrorDialogBuilder.buildConnectionErrorRoute);
    }
  }

  void markAsIgnored(BuildContext context) async {
    _performRequest(context, urlStrMarkAsIgnored);
  }

  void markAsLiked(BuildContext context) async {
    _performRequest(context, urlStrMarkAsLiked);
  }
}

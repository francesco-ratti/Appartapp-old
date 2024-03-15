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
        'http://10.0.2.2/appart-1.0-SNAPSHOT/api/images/apartments/${im['id']}',
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
      images.add(Image.asset(
        uri,
        fit: BoxFit.cover,
      ));
    }
    return images;
  }

  Apartment.fromMap(Map map)
      : id = map['id'],
        listingTitle = map["listingTitle"],
        description = map['description'],
        price = map['price'],
        address = map['address'],
        additionalExpenseDetail = map['additionalExpenseDetail'],
        imagesDetails = map['images'],
        images = fromImagesDetailsToImages(map['images']),
        owner = map['owner'] == null ? null : User.fromMap(map['owner']);

  Apartment.withLocalImages(this.id, this.listingTitle, this.description,
      this.price, this.address, this.additionalExpenseDetail, imagesUri)
      : images = fromImagesUriToImages(imagesUri);

  void _performRequest(BuildContext context, String urlStr) async {
    var dio = RuntimeStore().dio; //ok

    try {
      Response response = await dio.post(
        urlStr,
        data: {"apartmentid": id},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        Navigator.restorablePush(
            context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
      }
    } on DioException {
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

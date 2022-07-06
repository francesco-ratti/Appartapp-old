import 'package:appartapp/classes/connection_exception.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/exceptions/network_exception.dart';
import 'package:appartapp/exceptions/unauthorized_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Apartment {

  static final String urlStrMarkAsIgnored="";
  static final String urlStrMarkAsLiked="";


  final int id;
  final String listingTitle;
  final String description;
  final int price;
  final String address;
  final String additionalExpenseDetail;

  late List imagesDetails;
  final List<Image> images;

  User? owner;

  Apartment({
    required this.id,
    required this.listingTitle,
    required this.description,
    required this.price,
    required this.address,
    required this.additionalExpenseDetail,
    required this.imagesDetails,
    required this.images,
  });

  static List<Image> fromImagesDetailsToImages(List imagesDetails) {
    List<Image> images=[];
    for (final Map im in imagesDetails) {
      images.add(
          Image.network(
            'http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/images/apartments/${im['id']}',
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null  ? (loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes as int))
                      : null,
                ),
              );
            },
            fit: BoxFit.cover,
          )

      );
    }
    return images;
  }

  static List<Image> fromImagesUriToImages (List <String> imagesUri) {
    List<Image> images=[];
    for (final String uri in imagesUri) {
      images.add(Image.asset(uri));
    }
    return images;
  }

  Apartment.fromMap(Map map) :
        this.id=map['id'],
        this.listingTitle=map["listingTitle"],
        this.description=map['description'],
        this.price=map['price'],
        this.address=map['address'],
        this.additionalExpenseDetail=map['additionalExpenseDetail'],
        this.imagesDetails=map['images'],
        this.images=fromImagesDetailsToImages(map['images']),
        this.owner=map['owner'] == null ? null : User.fromMap(map['owner'])
  ;

  Apartment.withLocalImages(this.id,
      this.listingTitle,
      this.description,
      this.price,
      this.address,
      this.additionalExpenseDetail,
      imagesUri) :
        this.images=fromImagesUriToImages(imagesUri);


  void _performRequest(String urlStr) async {
    var dio = RuntimeStore().dio;

    try {
      Response response = await dio.post(
        urlStr,
        data: {"apartmentid": this.id},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 401)
        throw new UnauthorizedException();
      else if (response.statusCode != 200)
        throw new NetworkException();
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.cancel) {
        throw ConnectionException();
      }
      if (e.response?.statusCode == 401)
        throw new UnauthorizedException();
      else
        throw new NetworkException();
    }
  }

  void markAsIgnored() async {
    _performRequest(urlStrMarkAsIgnored);
  }

  void markAsLiked() async {
    _performRequest(urlStrMarkAsLiked);
  }
}
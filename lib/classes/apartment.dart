import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/exceptions/network_exception.dart';
import 'package:appartapp/exceptions/unauthorized_exception.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'apartment_handler.dart';

class Apartment {

  String urlStrMarkAsIgnored="";
  String urlStrMarkAsLiked="";


  final int id;
  final String listingTitle;
  final String description;
  final int price;
  final String address;
  final String additionalExpenseDetail;

  final List<String> imagesUrl;

  Apartment({
    required this.id,
    required this.listingTitle,
    required this.description,
    required this.price,
    required this.address,
    required this.additionalExpenseDetail,
    required this.imagesUrl,
  });

  Apartment.fromMap(Map map) :
        this.id=map['id'],
        this.listingTitle=map["listingTitle"],
        this.description=map['description'],
        this.price=map['price'],
        this.address=map['address'],
        this.additionalExpenseDetail=map['additionalExpenseDetail'],
        this.imagesUrl=map['imagesUrl'];

  void _performRequest(String urlStr) async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(ApartmentHandler().cookieJar));

    try {
      Response response = await dio.post(
        urlStr,
        data: {"email": RuntimeStore().getEmail(), "password": RuntimeStore().getPassword(), "apartmentid": this.id},
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
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:appartapp/classes/enum Gender.dart';

class User {
  int id;
  String email;
  String name;
  String surname;
  DateTime birthday;
  Gender gender;
  List imagesDetails;
  List<Image> images;

  static List<Image> fromImagesDetailsToImages(List imagesDetails) {
    List<Image> images=[];
    for (final Map im in imagesDetails) {
      images.add(
          Image.network(
            'http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/images/users/${im['id']}',
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
            //fit: BoxFit.cover,
          )

      );
    }
    return images;
  }

  User.fromMap(Map map) :
        this.id=map['id'],
        this.email=map["email"],
        this.name=map['name'],
        this.surname=map['surname'],
        this.birthday=DateTime.fromMillisecondsSinceEpoch(int.parse(map['birthday'])),
        this.gender= Gender.values.firstWhere((e) => e.toString() == 'Gender.' + map['gender']),
        this.imagesDetails=map['images'],
        this.images=fromImagesDetailsToImages(map['images']);
}
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:appartapp/classes/enum Gender.dart';
import 'package:appartapp/classes/enum Month.dart';

class User {
  int id;
  String email;
  String name;
  String surname;
  DateTime birthday;
  Gender gender;
  List imagesDetails;
  List<Image> images;

  ///// TO ADD IN THE SERVER //////////
  String bio; //User profile bio
  String reason; //Why are you looking for a new place to live?
  Month month; //What date would you want to move in?
  String work; //What kind of work do you do?
  String income; //What is a rough estimate of your income?
  String smoker; //Do you smoke?
  String pets; //Do you have pets?

  static List<Image> fromImagesDetailsToImages(List imagesDetails) {
    List<Image> images = [];
    for (final Map im in imagesDetails) {
      images.add(Image.network(
        'http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/images/users/${im['id']}',
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
        //fit: BoxFit.cover,
      ));
    }
    return images;
  }

  User.fromMap(Map map)
      : this.id = map['id'],
        this.email = map["email"],
        this.name = map['name'],
        this.surname = map['surname'],
        this.birthday = DateTime.fromMillisecondsSinceEpoch(map['birthday']),
        this.gender = Gender.values
            .firstWhere((e) => e.toString() == 'Gender.' + map['gender']),
        this.imagesDetails = map['images'],
        this.images = fromImagesDetailsToImages(map['images']),

        //TO UNCOMMENT WHEN THIS DATA WILL BE ORESENT ALSO ON THE SERVER

        // this.bio = map['bio'],
        // this.reason = map['reason'],
        // this.month = map['month'],
        // this.work = map['work'],
        // this.income = map['income'],
        // this.smoker = map['smoker'],
        // this.pets = map['pets'];

        //TO DELETE WHEN THE PREVIOUS BLOCK WILL BE UNCOMMENTED
        //FAKE INITIALISATION
        this.bio = "",
        this.reason = "Vivo a Roma e ho intenzione di studiare al Polimi",
        this.month = Month.September,
        this.work = "Student",
        this.income = "About 1000€ per month",
        this.smoker = "Yes, occasionally",
        this.pets = "No";

  User.temp(
      this.id,
      this.email,
      this.name,
      this.surname,
      this.birthday,
      this.gender,
      this.imagesDetails,
      this.images,
      this.bio,
      this.reason,
      this.month,
      this.work,
      this.income,
      this.smoker,
      this.pets);
}

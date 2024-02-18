import 'package:appartapp/enums/enum_gender.dart';
import 'package:appartapp/enums/enum_month.dart';
import 'package:appartapp/enums/enum_temporalq.dart';
import 'package:flutter/material.dart';

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
  Month? month; //What date would you want to move in?
  String job; //What kind of work do you do?
  String income; //What is a rough estimate of your income?
  TemporalQ? smoker; //Do you smoke?
  String pets; //Do you have any pet?

  bool isProfileComplete() {
    return (bio.trim().isNotEmpty &&
        reason.trim().isNotEmpty &&
        month != null &&
        job.isNotEmpty &&
        income.isNotEmpty &&
        smoker != null &&
        hasSelectedPets());
  }

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
        fit: BoxFit.cover,
      ));
    }
    return images;
  }

  bool hasSelectedPets() {
    return pets.isNotEmpty;
  }

  bool hasPets() {
    return pets.isNotEmpty && pets != "No";
  }

  User.fromMap(Map map)
      : id = map['id'],
        email = map["email"],
        name = map['name'],
        surname = map['surname'],
        birthday = DateTime.fromMillisecondsSinceEpoch(map['birthday']),
        gender = Gender.values
            .firstWhere((e) => e.toString() == 'Gender.' + map['gender']),
        imagesDetails = map['images'],
        images = fromImagesDetailsToImages(map['images']),

        //TO UNCOMMENT WHEN THIS DATA WILL BE ORESENT ALSO ON THE SERVER

        bio = map['bio'],
        reason = map['reason'],
        month = mapMonth(map['month']),
        job = map['job'],
        income = map['income'],
        smoker = mapTemporalQ(map['smoker']),
        pets = map['pets'];

  //TO DELETE WHEN THE PREVIOUS BLOCK WILL BE UNCOMMENTED
  //FAKE INITIALISATION
  /*
        this.bio = "",
        this.reason = "Vivo a Roma e ho intenzione di studiare al Polimi",
        this.month = Month.Settembre,
        this.job = "Student",
        this.income = "About 1000€ per month",
        this.smoker = "Yes, occasionally",
        this.pets = "No";
*/
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
      this.job,
      this.income,
      this.smoker,
      this.pets);

  static Month? mapMonth(String month) {
    if (month.trim().isEmpty) return null;

    return Month.values.firstWhere((e) => e.toString() == 'Month.' + month);
  }

  static TemporalQ? mapTemporalQ(String temporalQ) {
    if (temporalQ.trim().isEmpty) return null;

    return TemporalQ.values
        .firstWhere((e) => e.toString() == 'TemporalQ.' + temporalQ);
  }
}

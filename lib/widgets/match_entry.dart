import 'package:appartapp/entities/lessor_match.dart';
import 'package:flutter/material.dart';

class MatchEntry extends StatelessWidget {
  final LessorMatch match;
  final Function(BuildContext, LessorMatch) onTileTap;

  const MatchEntry({Key? key, required this.match, required this.onTileTap})
      : super(key: key);

  String timeDifferenceBuilder(Duration duration) {
    int minutes = duration.inMinutes;
    if (minutes == 0) {
      return "ora";
    }
    if (minutes == 1) {
      return "un minuto fa";
    }
    if (minutes < 60) {
      return "$minutes minuti fa";
    }
    int hours = duration.inHours;
    if (hours == 1) {
      return "un'ora fa";
    }
    if (hours < 24) {
      return "$hours ore fa";
    }
    int days = duration.inDays;
    if (days == 1) {
      return "un giorno fa";
    }
    if (days < 7 * 4) {
      return "$days giorni fa";
    }
    int weeks = days ~/ 7;
    /*if (weeks==1) {
      return "una settimana fa";
    }*/
    if (weeks < 4 * 4) {
      return "$weeks settimane fa";
    }
    int months = weeks ~/ 4;
    /*if (months==1) {
      return "un mese fa";
    }*/
    if (months < 12 * 2) {
      return "$months mesi fa";
    }
    int years = months ~/ 12;
    /*if (years==1) {
      return "un anno fa";
    }*/
    return "$years anni fa";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: match.apartment.images[0] != null
          ? CircleAvatar(backgroundImage: match.apartment.images[0].image)
          : const Icon(
              Icons.apartment_rounded,
            ),
      title: Text(match.apartment.listingTitle),
      subtitle: Text(
          "${match.apartment.description} - ${timeDifferenceBuilder(DateTime.now().difference(match.time))}"),
      onTap: () {
        onTileTap(context, match);

        /*
        for (final Image im
        in currentMatch.apartment.images) {
          precacheImage(im.image, context);
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text(currentMatch
                          .apartment
                          .listingTitle),
                      backgroundColor: Colors.brown,
                    ),
                    body: ApartmentViewer(
                        apartmentLoaded: true,
                        currentApartment:
                        currentMatch
                            .apartment,
                        owner: currentMatch
                            .apartment
                            .owner))));

        */
      },
    );
  }
}

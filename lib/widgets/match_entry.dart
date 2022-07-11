import 'package:appartapp/classes/lessor_match.dart';
import 'package:flutter/material.dart';

class MatchEntry extends StatelessWidget {
  final LessorMatch match;
  final Function(BuildContext, LessorMatch) onTileTap;

  const MatchEntry({Key? key, required this.match, required this.onTileTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: match.apartment!.images[0] != null
          ? CircleAvatar(backgroundImage: match.apartment!.images[0].image)
          : const Icon(
              Icons.apartment_rounded,
            ),
      title: Text(match.apartment.listingTitle),
      subtitle: Text(
          "${match.apartment.description} - ${DateTime.now().difference(match.time).inMinutes} minuti fa"),
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

import 'apartment.dart';

class ApartmentHandler {
  //SINGLETON PATTERN
  static final ApartmentHandler _apartment = ApartmentHandler._internal();

  factory ApartmentHandler() {
    return _apartment;
  }

  ApartmentHandler._internal();

  //useful as singleton since network functions will store session cookie here

  Apartment getNewApartment() {
    //TODO
    //fai richiesta al server e prendi la nuova lista di
    //urlImages e i dati del nuovo appartamento

    //just for testing

    return Apartment(listingTitle: "Bilocale Milano 2", description: "Casa molto carina 2, senza soffitto, senza cucina", price: 350, address: "Via di Paperone, Paperopoli", additionalExpenseDetail: "No, pagamento trimestrale", imagesUrl: [
      "assets/house2/img1.jpeg",
      "assets/house2/img2.jpeg",
      "assets/house2/img3.jpeg",
      "assets/house2/img4.jpeg",
    ]);
  }

  List<Apartment> getAllApartments() {
    //TODO
    return <Apartment>[];
  }
}
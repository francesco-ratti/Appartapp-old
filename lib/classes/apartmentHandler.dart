import 'apartment.dart';

class ApartmentHandler {

  Apartment currentApartment=Apartment(listingTitle: "Bilocale Milano", description: "Casa molto carina, senza soffitto, senza cucina", price: 350, address: "Via di Paperone, Paperopoli", additionalExpenseDetail: "No, pagamento trimestrale", imagesUrl: [
    "assets/house1/img1.jpeg",
    "assets/house1/img2.jpeg",
    "assets/house1/img3.jpeg",
    "assets/house1/img4.jpeg",
    "assets/house1/img5.jpeg",
  ]);

  String currentImageUrl = "";
  int currentIndex = 0;
  int numImages = 0;

  //SINGLETON PATTERN
  static final ApartmentHandler _apartment = ApartmentHandler._internal();

  factory ApartmentHandler() {
    return _apartment;
  }

  ApartmentHandler._internal();

  void getNewApartment() {
    //fai richiesta al server e prendi la nuova lista di
    //urlImages e i dati del nuovo appartamento

    //just for testing

    currentApartment=Apartment(listingTitle: "Bilocale Milano 2", description: "Casa molto carina 2, senza soffitto, senza cucina", price: 350, address: "Via di Paperone, Paperopoli", additionalExpenseDetail: "No, pagamento trimestrale", imagesUrl: [
      "assets/house2/img1.jpeg",
      "assets/house2/img2.jpeg",
      "assets/house2/img3.jpeg",
      "assets/house2/img4.jpeg",
    ]);

    numImages = currentApartment.imagesUrl.length;
    currentImageUrl = currentApartment.imagesUrl[0];
  }

  void initializeForTesting() {
    numImages = currentApartment.imagesUrl.length;
    currentImageUrl = currentApartment.imagesUrl[0];
  }

  void displayNext() {
    if (currentIndex < numImages - 1) {
      currentImageUrl = currentApartment.imagesUrl[++currentIndex];
    }
  }

  void displayPrevious() {
    if (currentIndex > 0) {
      currentImageUrl = currentApartment.imagesUrl[--currentIndex];
    }
  }

  String getTitle() {
    return currentApartment.listingTitle;
  }
}

class Appartment {
  List<String> urlImages = <String>[];
  String currentImage = "";
  int currentIndex = 0;
  int numImages = 0;
  String title = "";
  String location = "";
  int nLocali = 0;
  int price = 0;
  //aggiungi altre info

  //SINGLETON PATTERN
  static final Appartment _appartment = Appartment._internal();

  factory Appartment() {
    return _appartment;
  }

  Appartment._internal();

  void getNewAppartament() {
    //fai richiesta al server e prendi la nuova lista di
    //urlImages e i dati del nuovo appartamento

    //just for testing
    urlImages = [
      "assets/house2/img1.jpeg",
      "assets/house2/img2.jpeg",
      "assets/house2/img3.jpeg",
      "assets/house2/img4.jpeg",
    ];
    numImages = 4;
    currentImage = "assets/house2/img1.jpeg";
  }

  void initializeForTesting() {
    urlImages = [
      "assets/house1/img1.jpeg",
      "assets/house1/img2.jpeg",
      "assets/house1/img3.jpeg",
      "assets/house1/img4.jpeg",
      "assets/house1/img5.jpeg",
    ];
    numImages = 5;
    currentImage = "assets/house1/img1.jpeg";
  }

  void displayNext() {
    if (currentIndex < numImages - 1) {
      currentImage = urlImages[++currentIndex];
    }
  }

  void displayPrevious() {
    if (currentIndex > 0) {
      currentImage = urlImages[--currentIndex];
    }
  }

  String getTitle() {
    return title;
  }
}

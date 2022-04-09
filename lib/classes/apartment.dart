class Apartment {
  final String listingTitle;//="Bilocale Milano";
  final String description;//="Casa molto carina, senza soffitto, senza cucina";
  final int price;//=350;
  final String address;//="Via Roma, 27";
  final String additionalExpenseDetail;//="No, pagamento trimestrale";

  final List<String> imagesUrl;

  Apartment({
    required this.listingTitle,
    required this.description,
    required this.price,
    required this.address,
    required this.additionalExpenseDetail,
    required this.imagesUrl,
  });

  Apartment.fromMap(Map map) :
    this.listingTitle=map["listingTitle"],
    this.description=map['description'],
    this.price=map['price'],
    this.address=map['address'],
    this.additionalExpenseDetail=map['additionalExpenseDetail'],
    this.imagesUrl=map['imagesUrl'];

}
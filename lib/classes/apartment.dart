class Apartment {
  final String listingTitle;
  final String description;
  final int price;
  final String address;
  final String additionalExpenseDetail;

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
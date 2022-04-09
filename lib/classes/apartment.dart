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
}
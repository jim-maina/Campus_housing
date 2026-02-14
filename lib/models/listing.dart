class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String address;
  final List<String> imageUrls;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    this.imageUrls = const [],
  });
}

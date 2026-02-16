class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String address;
  final List<String> imageUrls;
  final String contactPhone; // landlord contact
  final String currency; // Currency code (e.g., 'KSH')

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.contactPhone,
    this.imageUrls = const [],
    this.currency = 'KSH', // Default to Kenyan Shillings
  });

  /// Format price with currency symbol
  String get formattedPrice {
    return '$currency ${price.toStringAsFixed(0)}';
  }
}

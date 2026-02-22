import 'package:flutter/foundation.dart';
import '../models/listing.dart';

/// A very simple ChangeNotifier that holds a list of house listings.
///
/// At first we'll just keep some hard‑coded data. Later you can replace this
/// with network/database logic.
class ListingProvider extends ChangeNotifier {
  final List<Listing> _listings = [];

  List<Listing> get listings => List.unmodifiable(_listings);

  void add(Listing listing) {
    _listings.add(listing);
    notifyListeners();
  }

  void remove(String id) {
    _listings.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  void update(Listing updated) {
    final idx = _listings.indexWhere((l) => l.id == updated.id);
    if (idx != -1) {
      _listings[idx] = updated;
      notifyListeners();
    }
  }

  /// Fake data for prototyping.
  void loadSampleData() {
    _listings.clear();
    _listings.addAll([
      Listing(
        id: '1',
        title: 'Cozy 2‑bed near campus',
        description: 'A comfortable two‑bedroom just a short walk from campus.',
        price: 15000,
        address: '123 College Ave',
        contactPhone: '+254700000001',
        imageUrls: [],
        currency: 'KSH',
      ),
      Listing(
        id: '2',
        title: 'Spacious house with yard',
        description: 'Perfect for a group of 4 students, includes parking.',
        price: 25000,
        address: '456 University St',
        contactPhone: '+254700000002',
        imageUrls: [],
        currency: 'KSH',
      ),
    ]);
    notifyListeners();
  }

  bool hasListingsInArea(String area) {
    return true; // For now, we assume all areas have listings. You can implement actual logic later.
  }
}

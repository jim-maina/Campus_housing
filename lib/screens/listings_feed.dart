import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listing_provider.dart';
import '../providers/auth_provider.dart';
import '../models/listing.dart';
import '../screens/listing_detail.dart';
import '../screens/area_listings_page.dart';
import '../screens/create_listing.dart';

class ListingsFeedPage extends StatefulWidget {
  final String? areaName;
  const ListingsFeedPage({super.key, this.areaName});

  @override
  State<ListingsFeedPage> createState() => _ListingsFeedPageState();
}

class _ListingsFeedPageState extends State<ListingsFeedPage> {
  double? _minPrice;
  double? _maxPrice;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> areas = ['Nchiru', 'Kianjai', 'Makutano', 'Other'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Listing> _applyFilter(List<Listing> list) {
    return list.where((l) {
      if (_minPrice != null && l.price < _minPrice!) return false;
      if (_maxPrice != null && l.price > _maxPrice!) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!l.title.toLowerCase().contains(q) &&
            !l.address.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final listingProv = context.watch<ListingProvider>();
    final authProv = context.watch<AuthProvider>();
    final rawListings = listingProv.listings;
    final listings = _applyFilter(rawListings);

    return Scaffold(
      appBar: AppBar(title: const Text('Browse Houses')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location or title',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                isDense: true,
              ),
              onChanged: (v) {
                setState(() {
                  _searchQuery = v;
                });
              },
            ),
          ),
          // Area selector row
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: areas.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final area = areas[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AreaListingsPage(areaName: area),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: 120,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        area,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          // Listings
          Expanded(
            child: listings.isEmpty
                ? const Center(child: Text('No listings match filter'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final item = listings[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListingDetailPage(listing: item),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 180,
                                child: item.imageUrls.isNotEmpty
                                    ? Image.network(
                                        item.imageUrls.first,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.home,
                                          size: 40,
                                          color: Colors.white70,
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(item.address),
                                    const SizedBox(height: 4),
                                    Text(item.formattedPrice),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (authProv.userType == 'landlord') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateListingPage(areaName: widget.areaName!),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Only landlords can add listings')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

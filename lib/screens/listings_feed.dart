import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/listing_provider.dart';
import '../providers/auth_provider.dart';
import '../models/listing.dart';
import 'listing_detail.dart';
import 'create_listing.dart';

class ListingsFeedPage extends StatefulWidget {
  const ListingsFeedPage({super.key});

  @override
  State<ListingsFeedPage> createState() => _ListingsFeedPageState();
}

class _ListingsFeedPageState extends State<ListingsFeedPage> {
  double? _minPrice;
  double? _maxPrice;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Browse Houses'),
        actions: [
          if (authProv.isLoggedIn)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'logout') authProv.logout();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout (${authProv.currentUser?.email ?? ''})'),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // search bar
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
          // filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Min price',
                      prefixText: 'KSH ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      setState(() {
                        _minPrice = double.tryParse(v);
                      });
                    },
                    controller: TextEditingController(
                      text: _minPrice != null ? _minPrice.toString() : '',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Max price',
                      prefixText: 'KSH ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      setState(() {
                        _maxPrice = double.tryParse(v);
                      });
                    },
                    controller: TextEditingController(
                      text: _maxPrice != null ? _maxPrice.toString() : '',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _minPrice = null;
                      _maxPrice = null;
                    });
                  },
                  tooltip: 'Clear filter',
                ),
              ],
            ),
          ),
          const Divider(),
          // listings
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ListingDetailPage(listing: item),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 180,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: item.imageUrls.isNotEmpty
                                          ? Image.network(
                                              item.imageUrls.first,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, _, _) =>
                                                  Container(
                                                    color: Colors.grey.shade300,
                                                    child: const Icon(
                                                      Icons.home,
                                                      size: 40,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
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
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        color: Colors.black54,
                                        child: Text(
                                          item.formattedPrice,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.address,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateListingPage()),
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

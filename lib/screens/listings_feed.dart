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

  List<Listing> _applyFilter(List<Listing> list) {
    return list.where((l) {
      if (_minPrice != null && l.price < _minPrice!) return false;
      if (_maxPrice != null && l.price > _maxPrice!) return false;
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
                if (v == 'logout') {
                  authProv.logout();
                }
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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            // filter controls
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            SizedBox(
              height: 500,
              child: listings.isEmpty
                  ? const Center(child: Text('No listings match filter'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: listings.length,
                      itemBuilder: (context, index) {
                        final item = listings[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ListingDetailPage(listing: item),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // image if available
                                  if (item.imageUrls.isNotEmpty)
                                    Image.network(
                                      item.imageUrls.first,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.home,
                                          size: 40,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.home,
                                        size: 40,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        const SizedBox(height: 4),
                                        Text(
                                          item.address,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.formattedPrice,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
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

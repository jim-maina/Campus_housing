import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/listing_provider.dart';
import '../models/listing.dart';
import 'listing_detail.dart';

class ListingsFeedPage extends StatelessWidget {
  const ListingsFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingProvider>();
    final listings = provider.listings;

    return Scaffold(
      appBar: AppBar(title: const Text('Browse Houses')),
      body: listings.isEmpty
          ? const Center(child: Text('No listings yet'))
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
                          builder: (_) => ListingDetailPage(listing: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // placeholder box for image
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.home, size: 40, color: Colors.white70),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(item.address,
                                    style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 4),
                                Text('\$${item.price.toStringAsFixed(0)}',
                                    style: Theme.of(context).textTheme.bodyLarge),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // for now add a sample
          provider.add(
            Listing(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: 'New listing',
              description: 'Description',
              price: 0,
              address: '',
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

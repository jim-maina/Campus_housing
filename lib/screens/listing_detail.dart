import 'package:flutter/material.dart';
import '../models/listing.dart';

class ListingDetailPage extends StatelessWidget {
  final Listing listing;

  const ListingDetailPage({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(listing.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(listing.address),
            const SizedBox(height: 8),
            Text(
              listing.formattedPrice,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(listing.description),
            const SizedBox(height: 20),
            // Contact section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Call: ${listing.contactPhone}')),
                    );
                  },
                  icon: const Icon(Icons.call),
                  label: const Text('Call'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Message: ${listing.contactPhone}'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.message),
                  label: const Text('Message'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

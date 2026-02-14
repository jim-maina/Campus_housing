import 'package:flutter/material.dart';
import '../models/listing.dart';

class ListingDetailPage extends StatelessWidget {
  final Listing listing;

  const ListingDetailPage({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(listing.address),
            const SizedBox(height: 8),
            Text('\$${listing.price.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(listing.description),
            // TODO: image gallery, map, contact buttons
          ],
        ),
      ),
    );
  }
}

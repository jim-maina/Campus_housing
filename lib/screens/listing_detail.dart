import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/listing.dart';

class ListingDetailPage extends StatelessWidget {
  final Listing listing;

  const ListingDetailPage({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(listing.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// Background image
          SizedBox(
            height: 300,
            width: double.infinity,
            child: listing.imageUrls.isNotEmpty
                ? Image.network(listing.imageUrls.first, fit: BoxFit.cover)
                : Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.home, size: 80),
                  ),
          ),

          /// Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 250),

                /// Glass container
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title + price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  listing.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                listing.formattedPrice,
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// Address
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  listing.address,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// Description
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(listing.description),

                          const SizedBox(height: 24),

                          /// Poster info (future expansion ready)
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 22,
                                child: Icon(Icons.person),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Posted by landlord",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          /// Contact buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Call: ${listing.contactPhone}',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.call),
                                  label: const Text("Call"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'WhatsApp: ${listing.contactPhone}',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.chat),
                                  label: const Text("WhatsApp"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

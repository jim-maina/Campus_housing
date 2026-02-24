// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listing_provider.dart';
import '../providers/auth_provider.dart';
import 'listing_detail.dart';
import 'create_listing.dart';

class AreaListingsPage extends StatefulWidget {
  final String areaName;
  const AreaListingsPage({
    super.key,
    required this.areaName,
    required String area,
  });

  @override
  State<AreaListingsPage> createState() => _AreaListingsPageState();
}

class _AreaListingsPageState extends State<AreaListingsPage> {
  @override
  Widget build(BuildContext context) {
    final listingProv = context.watch<ListingProvider>();
    final authProv = context.watch<AuthProvider>();
    final currentPhone = authProv.currentUser?.phone ?? '';
    final userType = authProv.userType;

    // Get listings for this area, optional: owner's listings on top
    final listings =
        listingProv.listings.where((l) => l.area == widget.areaName).toList()
          ..sort((a, b) {
            if (a.contactPhone == currentPhone) return -1; // owner first
            if (b.contactPhone == currentPhone) return 1;
            return 0;
          });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.areaName),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/picture 1.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: listings.isEmpty
                  ? Center(
                      child: Text(
                        'No listings available in ${widget.areaName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: listings.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = listings[index];
                        final isOwner = item.contactPhone == currentPhone;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ListingDetailPage(listing: item),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: isOwner
                                      ? Colors.deepPurple.withOpacity(0.35)
                                      : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: item.imageUrls.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      20,
                                                    ),
                                                    topRight: Radius.circular(
                                                      20,
                                                    ),
                                                  ),
                                              child: Image.network(
                                                item.imageUrls.first,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.home,
                                                        size: 40,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        20,
                                                      ),
                                                      topRight: Radius.circular(
                                                        20,
                                                      ),
                                                    ),
                                              ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 4,
                                                  color: Colors.black26,
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.formattedPrice,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.address,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: userType == 'landlord'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CreateListingPage(areaName: widget.areaName),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

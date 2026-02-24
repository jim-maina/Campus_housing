// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'area_listings_page.dart';

class ListingsFeedPage extends StatefulWidget {
  const ListingsFeedPage({super.key});

  @override
  State<ListingsFeedPage> createState() => _ListingsFeedPageState();
}

class _ListingsFeedPageState extends State<ListingsFeedPage> {
  final List<String> _areas = ['Nchiru', 'Mascan', 'Alaban'];

  void _addAreaDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Area'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter area name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newArea = controller.text.trim();
              if (newArea.isNotEmpty && !_areas.contains(newArea)) {
                setState(() => _areas.add(newArea));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, double width = 140}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // match login page
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25), // semi-transparent
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/picture 1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // DARK OVERLAY (like LoginPage)
          Container(color: Colors.black.withOpacity(0.25)),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Campus Housing',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 15, 14, 15),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Choose an area to see available listings',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade200),
                  ),
                ),
                const SizedBox(height: 24),

                // AREA CARDS
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount:
                        _areas.length +
                        (authProv.userType == 'landlord' ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      // Add area card
                      if (authProv.userType == 'landlord' &&
                          index == _areas.length) {
                        return GestureDetector(
                          onTap: _addAreaDialog,
                          child: _buildGlassCard(
                            width: 120,
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }

                      final area = _areas[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AreaListingsPage(area: area, areaName: area),
                            ),
                          );
                        },
                        child: _buildGlassCard(
                          child: Center(
                            child: Text(
                              area,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // ADMIN ANNOUNCEMENTS
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildGlassCard(
                      width: double.infinity,
                      child: const Center(
                        child: Text(
                          'Admin announcements will appear here',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
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

import 'package:flutter/material.dart';

class AreaCard extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback onTap;

  const AreaCard({
    super.key,
    required this.name,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          /// Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// Dark overlay
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.35),
            ),
          ),

          /// Area name
          Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

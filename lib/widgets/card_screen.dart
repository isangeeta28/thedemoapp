import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 18),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        child: Stack(
          children: [
            // Background image
            Image.network(
              'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Gradient overlay
            Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xFF0D0E1A),
                  ],
                ),
              ),
            ),

            // Rating badge (center top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2E43),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.star, color: Color(0xFF00E5FF), size: 16),
                      SizedBox(width: 4),
                      Text(
                        '4.1 (1,648)',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Favorite icon (top right)
            const Positioned(
              top: 16,
              right: 16,
              child: Icon(Icons.favorite_border,
                  color: Colors.white70, size: 26),
            ),

            // Frosted info section overlay at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(
                    color: const Color.fromARGB(255, 195, 200, 238).withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Toronto, Canada",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            InfoItem(
                              title: 'COST',
                              value: '\$200 CAD / night',
                              icon: FontAwesomeIcons.dollarSign,
                            ),
                            InfoItem(
                              title: 'DISTANCE',
                              value: '257km',
                              icon: FontAwesomeIcons.locationDot,
                            ),
                            InfoItem(
                              title: 'AVAILABLE',
                              value: 'Oct 24 - 26',
                              icon: FontAwesomeIcons.calendar,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, color: Color(0xFF00E5FF), size: 12),
            const SizedBox(width: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

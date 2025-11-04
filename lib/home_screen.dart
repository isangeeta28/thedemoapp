import 'dart:ui';

import 'package:demoapp/detail_screen.dart';
import 'package:demoapp/widgets/card_screen.dart';
import 'package:demoapp/widgets/animated_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _advancedDrawerController,
      openRatio: 0.85, // Drawer covers 85% of screen, home screen visible on right
      animationDuration: const Duration(milliseconds: 400),
      drawer: FrostedDrawer(
        onClose: () => _advancedDrawerController.hideDrawer(),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0E1A),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Search bar row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: _handleMenuButtonPressed,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2031),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.menu, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2031),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Where to?',
                            hintStyle: TextStyle(color: Colors.white54),
                            prefixIcon: Icon(Icons.search, color: Colors.white54),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Main content scroll
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (builder){
                          return const DetailScreen();
                        }));
                      },
                      child: const DestinationCard(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<AdvancedDrawerValue>(
          valueListenable: _advancedDrawerController,
          builder: (context, value, child) {
            return value.visible ? const SizedBox.shrink() : ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2737CF).withOpacity(0.1),
                      const Color(0xFF2737CF).withOpacity(0.02),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.08),
                      width: 0.6,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF1C8EF9), Color(0xFF2563EB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.circle_outlined, color: Colors.white, size: 22),
                    ),
                    Icon(Icons.flight, color: Colors.white.withOpacity(0.6), size: 26),
                    Icon(Icons.favorite_border, color: Colors.white.withOpacity(0.6), size: 26),
                    Icon(Icons.message, color: Colors.white.withOpacity(0.6), size: 26),
                  ],
                ),
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}



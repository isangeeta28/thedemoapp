import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedDrawerExample extends StatefulWidget {
  const AnimatedDrawerExample({super.key});

  @override
  State<AnimatedDrawerExample> createState() => _AnimatedDrawerExampleState();
}

class _AnimatedDrawerExampleState extends State<AnimatedDrawerExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      isDrawerOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D1E),
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: toggleDrawer,
                    ),
                    const Text(
                      "Home Screen",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Drawer
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double slide = 280 * _controller.value;
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(slide - 280, 0),
                    child: const FrostedDrawer(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class FrostedDrawer extends StatefulWidget {
  final VoidCallback? onClose;
  
  const FrostedDrawer({super.key, this.onClose});

  @override
  State<FrostedDrawer> createState() => _FrostedDrawerState();
}

class _FrostedDrawerState extends State<FrostedDrawer> {
  bool darkMode = true;

  Widget _buildMenuItem(
      {required IconData icon,
        required String title,
        bool selected = false,
        Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF1C8EF9).withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon, 
          color: selected 
              ? const Color(0xFF1C8EF9)
              : Colors.white.withOpacity(0.8), 
          size: 18
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ??
            const Icon(Icons.chevron_right, color: Colors.white54, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
      const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0F55E8).withOpacity(0.15),
                const Color(0xFF0F55E8).withOpacity(0.01),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    "Alice Portman",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Show Profile",
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: widget.onClose,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 16),

                // Account Settings Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Account Setting",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                _buildMenuItem(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  trailing: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C8EF9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "12",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.payment,
                  title: "Payment",
                  selected: true,
                ),
                _buildMenuItem(
                  icon: Icons.translate,
                  title: "Translate",
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: "Privacy",
                ),

                const SizedBox(height: 14),

                // Hosting Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Hosting",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _buildMenuItem(
                  icon: FontAwesomeIcons.list,
                  title: "Listing",
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.userGroup,
                  title: "Host",
                ),

                const SizedBox(height: 14),

                // More Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "More",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Dark Mode Toggle
                Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.dark_mode,
                        color: Colors.white, size: 18),
                    title: const Text(
                      "Dark Mode",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    trailing: Switch(
                      value: darkMode,
                      onChanged: (value) {
                        setState(() => darkMode = value);
                      },
                      activeColor: const Color(0xFF1C8EF9),
                    ),
                  ),
                ),

                _buildMenuItem(
                  icon: Icons.refresh,
                  title: "Update",
                ),
                
                const Spacer(),
                
                // Bottom indicator (thin white horizontal line)
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
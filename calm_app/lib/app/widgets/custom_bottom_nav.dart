

import 'package:calm_app/app/modules/home/views/discover_screen.dart';
import 'package:calm_app/app/modules/home/views/feature_screen.dart';
import 'package:calm_app/app/modules/home/views/main_home_screen.dart';
import 'package:calm_app/app/modules/home/views/profile_screen.dart';
import 'package:calm_app/app/modules/home/views/sleep_screen.dart';
import 'package:calm_app/app/modules/settings/views/settings_screen.dart';
import 'package:flutter/material.dart';


class ShoesBottomNavigationBar extends StatefulWidget {
  const ShoesBottomNavigationBar({super.key});

  @override
  State<ShoesBottomNavigationBar> createState() => _ShoesBottomNavigationBarState();
}

class _ShoesBottomNavigationBarState extends State<ShoesBottomNavigationBar> {
  int selectIndex = 0;
  final List<Widget> pages = [
    MainContent(),
    SleepScreen(),
    DiscoverScreen(),
    ProfileScreen(),
    SettingsScreen(), // Changed from FeatureScreen to SettingsScreen
  ];

  void onSelected(int index) {
    setState(() {
      selectIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: pages[selectIndex],
        ),
        BottomNavigationBar(
          backgroundColor: const Color(0xFF1B4B6F),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.nightlight_round), label: "Sleep"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Discover"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"), // Changed label from "Feature" to "Settings"
          ],
          currentIndex: selectIndex,
          onTap: onSelected,
        ),
      ],
    );
  }
}
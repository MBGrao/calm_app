import 'package:flutter/material.dart';
import '../../../widgets/custom_bottom_nav.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShoesBottomNavigationBar(),
    );
  }
} 
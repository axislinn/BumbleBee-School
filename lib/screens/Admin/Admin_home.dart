import 'package:bumblebee/screens/Admin+Teacher/bottom_nav/bottom_nav.dart';
import 'package:bumblebee/screens/Admin+Teacher/navi_drawer/navi_drawer_screen.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
      ),
      endDrawer: const NaviDrawer(),
      body: Center(
        child: Text('Welcome to the  Admin Home Page!'),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

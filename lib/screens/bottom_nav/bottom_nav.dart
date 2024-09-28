import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  late final int selectedIndex;
  late final Function(int) onItemTapped;

  //BottomNav({required this.selectedIndex, required this.onItemTapped, required int currentIndex, required void Function(int index) onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.class_rounded),
          label: 'Class',
        ),
      ],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
    );
  }
}

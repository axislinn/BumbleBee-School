// home_screen.dart

import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/data/repository/repositories/post_repository.dart';
import 'package:bumblebee/screens/createPostScreen/create_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Define your different pages here
    Center(child: Text('Home Page')),
    Center(child: Text('Chat Page')),
    Center(child: Text('Notification Page')),
    Center(child: Text('Class Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: _pages[
          _currentIndex], // Display the selected page based on the current index
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToCreatePostScreen(
              context); // Navigate to CreatePostScreen when FAB is pressed
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change the page when a new tab is selected
          });
        },
        items: [
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
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Class',
          ),
        ],
      ),
    );
  }

  void _navigateToCreatePostScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => PostBloc(postRepository: PostRepository()),
          child: CreatePostScreen(),
        ),
      ),
    );
  }
}

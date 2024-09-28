import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/data/repository/repositories/post_repository.dart';
import 'package:bumblebee/screens/CreatePostDialogContent/create_post_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<String> _titles = ['Home', 'Chat', 'Notification', 'Class'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<PostBloc>(
          create: (context) => PostBloc(
              postRepository: PostRepository()), // Correct instantiation
          child: AlertDialog(
            title: Text('Create Post'),
            content: CreatePostDialogContent(), // Dialog for creating the post
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          Center(child: Text('Home Page')),
          Center(child: Text('Chat Page')),
          Center(child: Text('Notification Page')),
          Center(child: Text('Class Page')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Class'),
        ],
      ),
    );
  }
}

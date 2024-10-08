import 'package:bumblebee_school/bloc/Admin+Teacher/post/post_bloc.dart';
import 'package:bumblebee_school/bloc/Admin+Teacher/post/post_event.dart';
import 'package:bumblebee_school/data/repositories/Admin+Teacher/post_repository.dart';
import 'package:bumblebee_school/screens/Admin+Teacher/bottom_nav/bottom_nav.dart';
import 'package:bumblebee_school/screens/Admin+Teacher/home/create_post_screen.dart';
import 'package:bumblebee_school/screens/Admin+Teacher/home/home_body.dart';
import 'package:bumblebee_school/screens/Admin+Teacher/navi_drawer/navi_drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Define different pages that will be shown when different tabs are clicked
  final List<Widget> _pages = [
    HomePage(), // Home page with posts, 
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(postRepository: PostRepository())
        ..add(
            FetchPosts()), // Trigger FetchPosts event when HomeScreen is created
      child: Scaffold(
        
        appBar: AppBar(
          automaticallyImplyLeading: false, 
          title: Text('Home Screen'),
        ),  
        endDrawer: const NaviDrawer(),

        body: _pages[
            _currentIndex], // Change the body based on the selected index
        floatingActionButton: _currentIndex == 0
            ? Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _navigateToCreatePostScreen(context);
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.grey,
                ),
              )
            : null, // Floating action button only for the home page
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomNav(
          // selectedIndex: _currentIndex,
          // onItemTapped: (index) {
          //   setState(() {
          //     _currentIndex = index;
          //   });
          // },
        ),
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
    ).then((_) {
      // Re-fetch posts after returning from post creation screen
      if (_currentIndex == 0) {
        context.read<PostBloc>().add(FetchPosts());
      }
    });
  }
}
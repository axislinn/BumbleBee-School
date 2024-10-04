// import 'package:flutter/material.dart';
// import 'package:bumblebee/screens/bottom_nav_to_page/bottom_nav.dart';
// import 'package:bumblebee/screens/bottom_nav_to_page/bottom_nav_page/chat_page.dart';
// import 'package:bumblebee/screens/bottom_nav_to_page/bottom_nav_page/class_page.dart';
// import 'package:bumblebee/screens/bottom_nav_to_page/bottom_nav_page/notification_page.dart';
// import 'package:bumblebee/screens/createPostScreen/create_post_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
// import 'package:bumblebee/data/repository/repositories/post_repository.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     Center(child: Text('Home Page')), // Home tab content
//     ChatPage(), // Chat tab content
//     NotificationPage(), // Notifications tab content
//     ClassPage(), // Class tab content
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: Stack(
//         children: [
//           _pages[
//               _currentIndex], // Display the selected page based on the current index
//           // Add a Floating Action Button only for the Home page (_currentIndex == 0)
//         ],
//       ),
//       floatingActionButton: _currentIndex == 0 // Show FAB only on Home Page
//           ? Padding(
//               padding:
//                   const EdgeInsets.only(bottom: 70.0), // Add padding to the FAB
//               child: FloatingActionButton(
//                 onPressed: () {
//                   _navigateToCreatePostScreen(
//                       context); // Navigate to create post screen
//                 },
//                 child: Icon(Icons.add),
//                 backgroundColor: Colors.grey,
//               ),
//             )
//           : null, // Don't show FAB on other pages
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       bottomNavigationBar: BottomNav(
//         selectedIndex: _currentIndex,
//         onItemTapped: (index) {
//           setState(() {
//             _currentIndex = index; // Change the page when a new tab is selected
//           });
//         },
//       ),
//     );
//   }

//   void _navigateToCreatePostScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BlocProvider(
//           create: (context) => PostBloc(postRepository: PostRepository()),
//           child: CreatePostScreen(),
//         ),
//       ),
//     ).then((_) {
//       // Optionally handle any post-navigation logic here
//     });
//   }
// }

import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_event.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';
import 'package:bumblebee/data/repository/repositories/post_repository.dart';
import 'package:bumblebee/screens/bodyForHomeScreen/home_body.dart';
import 'package:bumblebee/screens/bottom_nav_to_page/bottom_nav.dart';
import 'package:bumblebee/screens/bottom_nav_to_page/bottom_nav_page/chat_page.dart';
import 'package:bumblebee/screens/bottom_nav_to_page/bottom_nav_page/class_page.dart';
import 'package:bumblebee/screens/bottom_nav_to_page/bottom_nav_page/notification_page.dart';
import 'package:bumblebee/screens/createPostScreen/create_post_screen.dart';
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
    HomePage(), // Home page with posts
    ChatPage(), // Chat page placeholder
    NotificationPage(), // Notification page placeholder
    ClassPage(), // Class page placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(postRepository: PostRepository())
        ..add(
            FetchPosts()), // Trigger FetchPosts event when HomeScreen is created
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
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
          selectedIndex: _currentIndex,
          onItemTapped: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
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

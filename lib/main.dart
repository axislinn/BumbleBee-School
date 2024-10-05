import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/bloc/school_register_bloc/school_register_bloc.dart';
import 'package:bumblebee/data/repository/repositories/post_repository.dart';
import 'package:bumblebee/data/repository/repositories/school_repository.dart';
import 'package:bumblebee/screens/school/register_school.dart';
import 'package:bumblebee/screens/auth/splashscreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
// Adjust the import path if needed

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLoC Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          SplashScreen(), // Make sure this screen exists and is correctly implemented
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<PostBloc>(
//           create: (_) => PostBloc(
//               postRepository:
//                   PostRepository()), // Assuming PostBloc is your BLoC class
//           dispose: (_, bloc) =>
//               bloc.dispose(), // Dispose of the BLoC when not needed
//         ),
//         // You can add more providers here if needed
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'BLoC Example',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: SplashScreen(), // Wraps the app with PostBloc
//       ),
//     );
//   }
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       showSemanticsDebugger: false,
//       title: 'School Registration',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SchoolForm(), // Ensure this is wrapped inside a Scaffold
//     );
//   }
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => SchoolBloc(
//             schoolRepository: SchoolRepository(baseUrl: 'https://bumblebeeflutterdeploy-production.up.railway.app'),
//           ),
//         ),
//         // Add more providers if needed
//       ],
//       child: MaterialApp(
//         title: 'Bumblebee School Registration',
//         home: SchoolForm(),
//       ),
//     );
//   }
// }



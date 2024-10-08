import 'package:bumblebee_school/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';
import 'package:bumblebee_school/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee_school/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee_school/screens/Admin+Teacher/auth/splashscreen.dart';
import 'package:bumblebee_school/screens/Admin+Teacher/navi_drawer/drawer_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(
    BlocProvider(
      create: (context) => ClassBloc(ClassRepository(), UserRepository()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), 
      onGenerateRoute: DrawerRoutes.generateRoute
    );
  }
}
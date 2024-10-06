import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_bloc.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/student_repository.dart';
import 'package:bumblebee/screens/Admin+Teacher/navi_drawer/drawer/options_screen.dart';
import 'package:bumblebee/screens/Teacher/class_list.dart';
import 'package:flutter/material.dart';
import 'package:bumblebee/screens/Admin+Teacher/auth/loginscreen.dart';
import 'package:bumblebee/screens/Admin+Teacher/home/home_screen.dart';
import 'package:bumblebee/screens/Admin+Teacher/navi_drawer/drawer/info_screen.dart';
import 'package:bumblebee/screens/Admin+Teacher/navi_drawer/drawer/join_class_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';

class DrawerRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/joinClass':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ClassBloc>(
            create: (context) => ClassBloc(ClassRepository(), UserRepository()),
            child: JoinClassPage(),
          ),
        );
      case '/classlist':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<StudentBloc>(
            create: (context) => StudentBloc(ClassRepository(), UserRepository(), StudentRepository()),
            child: ClassList(),
          ),
        );
      // case '/classlist':
      //   return MaterialPageRoute(builder: (_) => ClassList());
      case '/info':
        return MaterialPageRoute(builder: (_) => InfoPage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => setting());
      case '/login':
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}

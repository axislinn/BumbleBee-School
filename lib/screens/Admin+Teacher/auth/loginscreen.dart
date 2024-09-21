import 'package:bumblebee/screens/Admin+Teacher/home/home_screen.dart';
import 'package:bumblebee/screens/Admin+Teacher/role_selection/role_seletion.dart';
import 'package:bumblebee/screens/Admin+Teacher/auth/signupscreen.dart';
import 'package:bumblebee/screens/Admin/register_school.dart';
import 'package:bumblebee/screens/Admin+Teacher/school_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bumblebee/bloc/auth/login_bloc/login_bloc.dart';
import 'package:bumblebee/bloc/auth/login_bloc/login_event.dart';
import 'package:bumblebee/bloc/auth/login_bloc/login_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login'),
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(userRepository: userRepository),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SchoolSelect()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${state.user.userName}!')),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Failed: ${state.error}')),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          // Disable button when loading
          _isButtonDisabled = state is LoginLoading;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isButtonDisabled
                        ? null
                        : () {
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginButtonPressed(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                          },
                    child: _isButtonDisabled
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => RoleSelectionScreen()),
                      );
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bumblebee/bloc/auth/signup_bloc/signup_bloc.dart';
import 'package:bumblebee/bloc/auth/signup_bloc/signup_event.dart';
import 'package:bumblebee/bloc/auth/signup_bloc/signup_state.dart';
import 'package:bumblebee/screens/Admin+Teacher/auth/loginscreen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  final String role;  // This will hold the role passed from the role selection screen

  // Constructor to accept role
  RegisterScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text('Register as $role'),  // Display the role in the title
      ),
      body: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: userRepository),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration Successful! Please login.')),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration Failed: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              bool isButtonDisabled = state is RegisterLoading;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _userNameController,
                        decoration: InputDecoration(labelText: 'User Name'),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                      ),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isButtonDisabled
                            ? null
                            : () {
                                final registerBloc = BlocProvider.of<RegisterBloc>(context);
                                registerBloc.add(
                                  RegisterButtonPressed(
                                    userName: _userNameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    confirmPassword: _confirmPasswordController.text,
                                    phone: _phoneController.text,
                                    role: role,  // Pass the selected role to the event
                                  ),
                                );
                              },
                        child: isButtonDisabled
                            ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('Register as $role'),  // Display the role in the button
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}



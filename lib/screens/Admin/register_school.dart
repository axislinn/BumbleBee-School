import 'package:bumblebee/bloc/Admin/school_register_bloc/school_register_bloc.dart';
import 'package:bumblebee/bloc/Admin/school_register_bloc/school_register_event.dart';
import 'package:bumblebee/bloc/Admin/school_register_bloc/school_register_state.dart';
import 'package:bumblebee/data/repositories/Admin/school_repository.dart';
import 'package:bumblebee/screens/Admin+Teacher/home/home_screen.dart';
import 'package:bumblebee/screens/Admin/Admin_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolForm extends StatelessWidget {
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final schoolRepository = SchoolRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text('Register School'),
      ),
      body: BlocProvider<SchoolBloc>(
        create: (context) => SchoolBloc(schoolRepository: schoolRepository),
        child: BlocListener<SchoolBloc, SchoolState>(
          listener: (context, state) {
            if (state is SchoolSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('School registered successfully!')),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AdminHomePage()),
              );
            } else if (state is SchoolFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to register: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<SchoolBloc, SchoolState>(
            builder: (context, state) {
              bool isButtonDisabled = state is SchoolLoading;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: schoolNameController,
                      decoration: InputDecoration(labelText: 'School Name'),
                    ),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isButtonDisabled
                          ? null
                          : () {
                              final schoolBloc = BlocProvider.of<SchoolBloc>(context);
                              schoolBloc.add(
                                RegisterSchool(
                                  schoolName: schoolNameController.text,
                                  address: addressController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
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
                          : Text('Register School'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


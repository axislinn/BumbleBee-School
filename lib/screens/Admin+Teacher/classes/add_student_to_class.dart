import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_state.dart';
import 'package:bumblebee/componemts/MyButton.dart';
import 'package:bumblebee/componemts/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStudentToClass extends StatelessWidget {
  final String classId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  AddStudentToClass({required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student to Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<ClassBloc, ClassState>(
          listener: (context, state) {
            // Handle success and error states
            if (state is AddStudentSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Student added successfully!'),
              ));
              _nameController.clear(); // Clear fields
              _dobController.clear();
            } else if (state is AddStudentErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error adding student: ${state.message}'),
              ));
            }
          },
          child: Column(
            children: [
              MyTextField(
                hintText: "Student Name",
                obscureText: false,
                controller: _nameController,
              ),

              SizedBox(height: 20),

              MyTextField(
                hintText: "Date of Birth",
                obscureText: false,
                controller: _dobController,
              ),

              SizedBox(height: 20),

              MyButton(onTap: () => _addStudent(context), btnText: "Add Student"),
            ],
          ),
        ),
      ),
    );
  }

  // Function to add student
  void _addStudent(BuildContext context) {
    String studentName = _nameController.text;
    String dob = _dobController.text;

    if (studentName.isNotEmpty && dob.isNotEmpty) {
      context.read<ClassBloc>().add(AddStudentEvent(classId, studentName, dob));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid details'),
      ));
    }
  }
}

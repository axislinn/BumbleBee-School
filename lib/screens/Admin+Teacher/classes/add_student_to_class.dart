import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddStudentToClass extends StatefulWidget {
  final String classId;

  AddStudentToClass({required this.classId});

  @override
  _AddStudentToClassState createState() => _AddStudentToClassState();
}

class _AddStudentToClassState extends State<AddStudentToClass> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isButtonDisabled = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student to Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<StudentBloc, StudentState>(
          listener: (context, state) {
            if (state is AddStudentSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Student added successfully!'),
              ));
              _nameController.clear(); // Clear fields
              _dobController.clear();
              setState(() {
                _isButtonDisabled = false;
              });
              
              // Fetch the updated student list
              context.read<StudentBloc>().add(FetchStudentsEvent(widget.classId));
              
              // Optionally, navigate back or close the dialog
              // Navigator.pop(context);
            } else if (state is AddStudentErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error adding student: ${state.message}'),
              ));
              setState(() {
                _isButtonDisabled = false;
              });
            }
          },
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Student name'),
                controller: _nameController,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Date of birth',
                    ),
                    controller: _dobController,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        setState(() {
                          _isButtonDisabled = true;
                        });
                        _addStudent(context);
                      },
                child: _isButtonDisabled
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addStudent(BuildContext context) {
    String studentName = _nameController.text;
    String dob = _dobController.text;

    if (studentName.isNotEmpty && dob.isNotEmpty) {
      context
          .read<StudentBloc>()
          .add(AddStudentEvent(widget.classId, studentName, dob));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid details'),
      ));
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}

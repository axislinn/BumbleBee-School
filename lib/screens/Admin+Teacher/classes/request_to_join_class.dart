import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_state.dart';
import 'package:bumblebee/componemts/MyButton.dart';
import 'package:bumblebee/componemts/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestToJoinClass extends StatelessWidget {
  final TextEditingController _classCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ClassBloc, ClassState>(
          builder: (context, state) {
            // Handle success and error states
            if (state is JoinClassSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Requested to join class successfully'),
                ));
              });
            } else if (state is JoinClassErrorState) {
              return Center(child: Text('Error joining class: ${state.message}'));
            }

            return Column(
              children: [
                MyTextField(
                  hintText: "Class code",
                  obscureText: false,
                  controller: _classCodeController,
                ),

                SizedBox(height: 20),
                
                MyButton(onTap: _requestToJoinClass, btnText: "Join Class"),
              ],
            );
          },
        ),
      ),
    );
  }

  // function of the button
  void _requestToJoinClass(BuildContext context) {
    String classCode = _classCodeController.text;
    if (classCode.isNotEmpty) {
      context.read<ClassBloc>().add(RequestToJoinClassEvent(classCode));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid class code'),
      ));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final bool isNumberField;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.isNumberField = false, // Default is false if not specified
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
       width: 350,
       height: 50,
       child: TextField(
         controller: controller,
         style: const TextStyle(fontSize: 16),
         obscureText: obscureText,
         keyboardType: isNumberField ? TextInputType.number : TextInputType.text,
         inputFormatters: isNumberField ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
         decoration: InputDecoration(
           hintText: hintText,
           hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5), // Reduce opacity to 50%
              fontSize: 16,
           ),
           contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(10.0),
             borderSide: const BorderSide(color: Colors.red, width: 2.0),
           ),
           // Set the border color when the text field is focused
           focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(10.0),
             borderSide: const BorderSide(color: Colors.red, width: 2.0),
           ),
           // Set the border color when the text field is enabled but not focused
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(10.0),
             borderSide: const BorderSide(color: Colors.red, width: 2.0),
           ),
           // Set the border color when there's an error
           errorBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(10.0),
             borderSide: const BorderSide(color: Colors.red, width: 2.0),
           ),
           // Set the border color when the error is being corrected
           focusedErrorBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(10.0),
             borderSide: const BorderSide(color: Colors.red, width: 2.0),
           ),
         ),
       ),
      ),
    );

  }
}

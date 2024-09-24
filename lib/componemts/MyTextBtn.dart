import 'package:flutter/material.dart';

class MyTextBtn extends StatelessWidget {
  final Function onPressed; 
  final String btnText;

  const MyTextBtn({super.key, required this.onPressed, required this.btnText});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(
        btnText,
        style: TextStyle(
          color: Colors.red,
          decoration: TextDecoration.underline,
          decorationColor: Colors.red,          // Set the underline color to red
          decorationThickness: 2.0,  
        ),
      ),
    );
  }
}
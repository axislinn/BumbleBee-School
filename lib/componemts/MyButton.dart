import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function onTap; 
  final String btnText;

  const MyButton({super.key,  required this.onTap, required this.btnText}); // Accept onTap as a required parameter

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(), // Call the onTap function
      child: Center(
        child: Container(
          width: 350.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              btnText,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }
}

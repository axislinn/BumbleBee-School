import 'package:bumblebee/screens/Teacher/link_school.dart';
import 'package:bumblebee/screens/Admin/register_school.dart';
import 'package:flutter/material.dart';

class SchoolSelect extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('School'),
      
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SchoolForm(),
                  ),
                );
              },
              child: Text('Register School'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LinkSchool(),
                  ),
                );
              },
              child: Text('Link With School'),
            ),
          ],
        ),
      ),
    );
  }
}

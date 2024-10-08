import 'package:bumblebee_school/screens/Admin+Teacher/auth/signupscreen.dart';
import 'package:flutter/material.dart'; 

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Role'),
      
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(role: 'admin'),
                  ),
                );
              },
              child: Text('Admin'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(role: 'teacher'),
                  ),
                );
              },
              child: Text('Teacher'),
            ),
          ],
        ),
      ),
    );
  }
}

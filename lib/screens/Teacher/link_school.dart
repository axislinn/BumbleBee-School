import 'package:bumblebee/screens/Teacher/Teacher_home.dart';
import 'package:flutter/material.dart';

class LinkSchool extends StatefulWidget {
  const LinkSchool({super.key});

  @override
  _LinkSchoolState createState() => _LinkSchoolState();
}

class _LinkSchoolState extends State<LinkSchool> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void _handleButtonPress() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network request or processing delay
    await Future.delayed(Duration(seconds: 2));

    final inputText = _controller.text;
    print('Button pressed with input: $inputText');

    // Navigate to the Teacher Home Page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TeacherHomePage()),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Link School'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Token',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleButtonPress,
              child: _isLoading
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: const Color.fromARGB(255, 106, 24, 121),
                      ),
                    )
                  : const Text('Link With School'),
            ),
          ],
        ),
      ),
    );
  }
}
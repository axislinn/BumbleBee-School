import 'package:flutter/material.dart';

class LinkSchool extends StatefulWidget {
  const LinkSchool({super.key});

  @override
  _LinkSchoolState createState() => _LinkSchoolState();
}

class _LinkSchoolState extends State<LinkSchool> {
  final TextEditingController _controller = TextEditingController();

  void _handleButtonPress() {
    // Handle the button press action here
    final inputText = _controller.text;
    print('Button pressed with input: $inputText');
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
              onPressed: _handleButtonPress,
              child: const Text('Link With School'),
            ),
          ],
        ),
      ),
    );
  }
}

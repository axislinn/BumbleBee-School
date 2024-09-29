import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_event.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String? selectedClass;
  String? selectedGrade;
  String? selectedContentType;
  File? _image;

  final List<String> grades = ['Grade 1', 'Grade 2', 'Grade 3'];
  final List<String> classes = ['Class A', 'Class B', 'Class C'];
  final List<String> contentTypes = ['feed', 'announcement'];
  final ImagePicker _picker = ImagePicker();

  final String schoolId = 'your_school_id_here';

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Set the picked image file
      });
    }
  }

  // Form validation logic
  String? _validateForm() {
    if (_headingController.text.isEmpty) {
      return 'Please enter a heading';
    }
    if (selectedGrade == null) {
      return 'Please select a grade';
    }
    if (selectedClass == null) {
      return 'Please select a class';
    }
    if (selectedContentType == null) {
      return 'Please select a content type';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );
        } else if (state is PostSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Post created successfully!')));
        } else if (state is PostFailure) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to create post')));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dropdown for Grade and Class
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedGrade,
                        items: grades.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedGrade = newValue;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Select Grade'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedClass,
                        items: classes.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedClass = newValue;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Select Class'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Dropdown for Content Type
                DropdownButtonFormField<String>(
                  value: selectedContentType,
                  items: contentTypes.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedContentType = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Content Type'),
                ),

                // Heading TextField
                TextField(
                  controller: _headingController,
                  decoration: InputDecoration(labelText: 'Heading'),
                ),

                // Body TextField
                SizedBox(height: 10),
                TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(labelText: 'Body'),
                ),

                // Image Picker
                SizedBox(height: 30),
                _image != null
                    ? Image.file(_image!,
                        height: 300, width: 300, fit: BoxFit.cover)
                    : TextButton.icon(
                        icon: Icon(Icons.photo),
                        label: Text('Add Photo'),
                        onPressed: _pickImage, // Open image picker
                      ),

                // Action buttons (Cancel and Create Post)
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final validationError = _validateForm();
                        if (validationError != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(validationError)));
                        } else {
                          // Dispatch CreatePost event with the selected image
                          context.read<PostBloc>().add(CreatePost(
                                heading: _headingController.text,
                                body: _bodyController.text,
                                contentType: selectedContentType!,
                                classId: selectedClass!,
                                schoolId: schoolId,
                                contentPicture:
                                    _image, // Pass the selected image
                              ));
                        }
                      },
                      child: Text('Create Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

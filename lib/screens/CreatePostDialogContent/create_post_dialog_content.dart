import 'dart:io';

import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_event.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostDialogContent extends StatefulWidget {
  @override
  _CreatePostDialogContentState createState() =>
      _CreatePostDialogContentState();
}

class _CreatePostDialogContentState extends State<CreatePostDialogContent> {
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

  // Define or receive schoolId here
  final String schoolId = 'your_school_id_here';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
      child: Dialog(
        insetPadding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Create Post',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                    controller: _headingController,
                    decoration: InputDecoration(labelText: 'Heading')),
                SizedBox(height: 10),
                TextField(
                    controller: _bodyController,
                    decoration: InputDecoration(labelText: 'Body (optional)')),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                _image != null
                    ? Image.file(_image!,
                        height: 100, width: 100, fit: BoxFit.cover)
                    : TextButton.icon(
                        icon: Icon(Icons.photo),
                        label: Text('Add Photo'),
                        onPressed: _pickImage),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final validationError = _validateForm();
                    if (validationError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(validationError)));
                    } else {
                      context.read<PostBloc>().add(CreatePost(
                            heading: _headingController.text,
                            body: _bodyController.text,
                            //contentPicture:
                            //_image, // Ensure this is included if needed
                            contentType: selectedContentType!,
                            classId: selectedClass!,
                            schoolId: schoolId,
                          ));
                    }
                  },
                  child: Text('Create Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

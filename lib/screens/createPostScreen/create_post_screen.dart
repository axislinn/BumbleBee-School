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
        if (state is PostSuccess) {
          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post created successfully!')),
          );
          // Navigate back to home after a brief delay
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context)
                .pop(); // Navigate back to the previous screen (home)
          });
        } else if (state is PostFailure) {
          // Show failure message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create post')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Post', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Grade and Class',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
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
                        decoration: InputDecoration(
                          labelText: 'Select Grade',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
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
                        decoration: InputDecoration(
                          labelText: 'Select Class',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                  decoration: InputDecoration(
                    labelText: 'Select Content Type',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _headingController,
                  decoration: InputDecoration(
                    labelText: 'Heading',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                    labelText: 'Body',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2, // Allow multiple lines
                ),
                SizedBox(height: 20),
                Center(
                  child: _image != null
                      ? Image.file(_image!,
                          height: 200, width: 400, fit: BoxFit.cover)
                      : TextButton.icon(
                          icon: Icon(Icons.photo, color: Colors.blue),
                          label: Text('Add Photo',
                              style: TextStyle(color: Colors.blue)),
                          onPressed: _pickImage,
                        ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Align buttons to the right
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .red, // Background color for the cancel button
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                      ),
                      child:
                          Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 10), // Space between the buttons
                    BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                        // Disable button when loading
                        return ElevatedButton(
                          onPressed: state is PostLoading
                              ? null // Disable button if in loading state
                              : () {
                                  final validationError = _validateForm();
                                  if (validationError != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(validationError)),
                                    );
                                  } else {
                                    context.read<PostBloc>().add(CreatePost(
                                          heading: _headingController.text,
                                          body: _bodyController.text,
                                          contentType: selectedContentType!,
                                          classId: selectedClass!,
                                          schoolId: schoolId,
                                          contentPictures: _image,
                                        ));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .blue, // Background color for the create post button
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                          child: state is PostLoading
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Creating Post',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                )
                              : Text('Create Post',
                                  style: TextStyle(color: Colors.white)),
                        );
                      },
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

  @override
  void dispose() {
    _headingController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}

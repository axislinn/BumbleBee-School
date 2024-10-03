import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_event.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';
import 'package:permission_handler/permission_handler.dart';

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
  List<File> _images = []; // List to store multiple images
  List<File> _documents = []; // List to store selected documents

  final List<String> grades = ['Grade 1', 'Grade 2', 'Grade 3'];
  final List<String> classes = ['Class A', 'Class B', 'Class C'];
  final List<String> contentTypes = ['feed', 'announcement'];
  final ImagePicker _picker = ImagePicker();

  final String schoolId = 'your_school_id_here'; // Set your school ID here

  // Pick images from gallery
  Future<void> _pickImage() async {
    final pickedFiles =
        await _picker.pickMultiImage(); // Allow picking multiple images
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

// Pick documents using file picker
  Future<void> _pickDocuments() async {
    try {
      // Check the status of the storage permission
      var status = await Permission.storage.status;
      if (status.isDenied) {
        // Request the storage permission
        await Permission.storage.request();
      }

      // Check the status of the photos permission
      status = await Permission.photos.status;
      if (status.isDenied) {
        // Request the photos permission
        await Permission.photos.request();
      }

      // Pick files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx'],
      );

      if (result != null) {
        setState(() {
          if (result.files.isNotEmpty) {
            _documents = result.files.map((file) => File(file.path!)).toList();
          } else {
            _documents = [];
          }
        });
      } else {
        setState(() {
          _documents = [];
        });
        print("No documents selected.");
      }
    } catch (e) {
      print("Error picking documents: $e");
      // You can also show an error message to the user here if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking documents: $e')),
      );
    }
  }

  // Validate form fields
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
                // Grade and Class selection
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

                // Content type selection
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

                // Heading input
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

                // Body input
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

                // Image display or picker
                Center(
                  child: Column(
                    children: [
                      _images.isNotEmpty
                          ? Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: _images
                                  .map((image) => Stack(
                                        children: [
                                          Image.file(image,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _images.remove(
                                                      image); // Remove image
                                                });
                                              },
                                              child: Icon(Icons.cancel,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage, // Open image picker
                        child: Container(
                          width: 400,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey, width: 3),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 40,
                            ),
                            // Plus icon
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                // Document picker
                Center(
                  child: _documents.isNotEmpty
                      ? Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: _documents.map((document) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.green,
                                    size: 50,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    document.path.split('/').last,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow
                                        .ellipsis, // Handle long names
                                    maxLines: 2, // Limit to two lines
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      : TextButton.icon(
                          icon: Icon(Icons.upload_file, color: Colors.blue),
                          label: Text(
                            'Add Documents',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: _pickDocuments,
                        ),
                ),

                SizedBox(height: 30),

                // Action buttons
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Align buttons to the right
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Cancel button color
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 10), // Space between buttons
                    BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
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
                                          classId: selectedClass!,
                                          schoolId: schoolId,
                                          contentType: selectedContentType!,
                                          contentPictures: _images,
                                          documents:
                                              _documents!, // Include documents
                                        ));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Submit button color
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state is PostLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text('Submit',
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
}

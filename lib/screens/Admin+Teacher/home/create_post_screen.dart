// import 'dart:convert';
// import 'dart:io';
// import 'package:bumblebee/bloc/Admin+Teacher/post/post_bloc.dart';
// import 'package:bumblebee/bloc/Admin+Teacher/post/post_event.dart';
// import 'package:bumblebee/bloc/Admin+Teacher/post/post_state.dart';
// import 'package:bumblebee/data/repositories/Admin+Teacher/post_repository.dart';
// import 'package:bumblebee/models/Admin+Teacher/post_model.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart'; // For making HTTP requests

// class CreatePostScreen extends StatefulWidget {
//   @override
//   _CreatePostScreenState createState() => _CreatePostScreenState();
// }

// class _CreatePostScreenState extends State<CreatePostScreen> {
//   final PostRepository postRepository = PostRepository();
//   final TextEditingController _headingController = TextEditingController();
//   final TextEditingController _bodyController = TextEditingController();
//   String? selectedClassName;
//   String? selectedGradeName;
//   List<String> classNames = [];
//   List<String> gradeNames = [];
//   String? selectedContentType;
//   List<File> _images = []; // List to store multiple images
//   List<File> _documents = []; // List to store selected documents
//   final List<String> contentTypes = ['feed', 'announcement'];
//   final ImagePicker _picker = ImagePicker();
//   String? schoolId;
//   String? schoolName;

//   // Create an instance of PostRepository
//   @override
//   void initState() {
//     super.initState();
//     _fetchClassAndGradeNames(); // Fetch data when the screen initializes
//     _fetchSchoolData();
//   }

//   // Fetch school data (schoolId and schoolName)
//   Future<void> _fetchSchoolData() async {
//     // Retrieve token from SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('userToken'); // Replace with your token key

//     if (token != null) {
//       try {
//         Map<String, String> schoolData = await PostRepository.fetchSchoolData(token);
//         setState(() {
//           schoolId = schoolData["schoolId"];
//           schoolName = schoolData["schoolName"];
//         });
//       } catch (e) {
//         print("Error fetching school data: $e");
//       }
//     } else {
//       // Handle case when token is not available
//       print("Token not found!");
//     }
//   }
// }

// // Fetch class names, grade names, and posts to extract schoolId
//   Future<void> _fetchClassAndGradeNames() async {
//     try {
//       // Retrieve token from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('userToken');

//       if (token != null) {
//         // Fetch class names and grade names
//         List<String> fetchedClassNames =
//             await PostRepository.fetchClassNames(token);
//         List<String> fetchedGradeNames =
//             await PostRepository.fetchGradeNames(token);

//         setState(() {
//           classNames = fetchedClassNames;
//           gradeNames = fetchedGradeNames;
//         });
//       } else {
//         print("Token not found!");
//       }
//     } catch (error) {
//       print("Error fetching data: $error");
//     }
//   }

//   // Pick images from gallery
//   Future<void> _pickImage() async {
//     final pickedFiles =
//         await _picker.pickMultiImage(); // Allow picking multiple images
//     if (pickedFiles != null) {
//       setState(() {
//         _images = pickedFiles.map((file) => File(file.path)).toList();
//       });
//     }
//   }

// // Pick documents using file picker
//   Future<void> _pickDocuments() async {
//     try {
//       // Check the status of the storage permission
//       var status = await Permission.storage.status;
//       if (status.isDenied) {
//         // Request the storage permission
//         await Permission.storage.request();
//       }

//       // Check the status of the photos permission
//       status = await Permission.photos.status;
//       if (status.isDenied) {
//         // Request the photos permission
//         await Permission.photos.request();
//       }

//       // Pick files
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx'],
//       );

//       if (result != null) {
//         setState(() {
//           if (result.files.isNotEmpty) {
//             _documents = result.files.map((file) => File(file.path!)).toList();
//           } else {
//             _documents = [];
//           }
//         });
//       } else {
//         setState(() {
//           _documents = [];
//         });
//         print("No documents selected.");
//       }
//     } catch (e) {
//       print("Error picking documents: $e");
//       // You can also show an error message to the user here if needed
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking documents: $e')),
//       );
//     }
//   }

//   // Validate form fields
//   String? _validateForm() {
//     if (_headingController.text.isEmpty) {
//       return 'Please enter a heading';
//     }
//     if (selectedGradeName == null) {
//       return 'Please select a grade';
//     }
//     if (selectedClassName == null) {
//       return 'Please select a class';
//     }
//     if (selectedContentType == null) {
//       return 'Please select a content type';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<PostBloc, PostState>(
//       listener: (context, state) {
//         if (state is PostSuccess) {
//           // Show success message and navigate back
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Post created successfully!')),
//           );
//           // Navigate back to home after a brief delay
//           Future.delayed(Duration(seconds: 1), () {
//             Navigator.of(context)
//                 .pop(); // Navigate back to the previous screen (home)
//           });
//         } else if (state is PostFailure) {
//           // Show failure message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to create post')),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Create Post', style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.grey,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Grade and Class selection
//                 Text('Select Grade and Class',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: selectedGradeName,
//                         items: gradeNames.map((String value) {
//                           return DropdownMenuItem<String>(
//                               value: value, child: Text(value));
//                         }).toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             selectedGradeName = newValue;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           labelText: 'Select Grade',
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: selectedClassName,
//                         items: classNames.map((String value) {
//                           return DropdownMenuItem<String>(
//                               value: value, child: Text(value));
//                         }).toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             selectedClassName = newValue;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           labelText: 'Select Class',
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),

//                 // Content type selection
//                 DropdownButtonFormField<String>(
//                   value: selectedContentType,
//                   items: contentTypes.map((String value) {
//                     return DropdownMenuItem<String>(
//                         value: value, child: Text(value));
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedContentType = newValue;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Select Content Type',
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 20),

//                 // Heading input
//                 TextField(
//                   controller: _headingController,
//                   decoration: InputDecoration(
//                     labelText: 'Heading',
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 20),

//                 // Body input
//                 TextField(
//                   controller: _bodyController,
//                   decoration: InputDecoration(
//                     labelText: 'Body',
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   maxLines: 2, // Allow multiple lines
//                 ),
//                 SizedBox(height: 20),

//                 // Image display or picker
//                 Center(
//                   child: _images.isNotEmpty
//                       ? Wrap(
//                           spacing: 10,
//                           runSpacing: 10,
//                           children: _images
//                               .map((image) => Image.file(image,
//                                   height: 100, width: 100, fit: BoxFit.cover))
//                               .toList(),
//                         )
//                       : TextButton.icon(
//                           icon: Icon(Icons.photo, color: Colors.blue),
//                           label: Text('Add Photos',
//                               style: TextStyle(color: Colors.blue)),
//                           onPressed: _pickImage,
//                         ),
//                 ),
//                 SizedBox(height: 20),
//                 // Document picker
//                 Center(
//                   child: _documents.isNotEmpty
//                       ? Wrap(
//                           spacing: 10,
//                           runSpacing: 10,
//                           children: _documents.map((document) {
//                             return Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.insert_drive_file,
//                                     color: Colors.green, size: 50),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   document.path
//                                       .split('/')
//                                       .last, // Display the file name
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 12),
//                                 ),
//                               ],
//                             );
//                           }).toList(),
//                         )
//                       : TextButton.icon(
//                           icon: Icon(Icons.upload_file, color: Colors.blue),
//                           label: Text('Add Documents',
//                               style: TextStyle(color: Colors.blue)),
//                           onPressed: _pickDocuments,
//                         ),
//                 ),

//                 SizedBox(height: 30),

//                 // Action buttons
//                 Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.end, // Align buttons to the right
//                   children: [
//                     ElevatedButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red, // Cancel button color
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child:
//                           Text('Cancel', style: TextStyle(color: Colors.white)),
//                     ),
//                     SizedBox(width: 10), // Space between buttons
//                     BlocBuilder<PostBloc, PostState>(
//                       builder: (context, state) {
//                         return ElevatedButton(
//                           onPressed: state is PostLoading
//                               ? null // Disable button if in loading state
//                               : () {
//                                   final validationError = _validateForm();
//                                   if (validationError != null) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text(validationError)),
//                                     );
//                                   } else if (selectedClassName == null ||
//                                       selectedGradeName == null ||
//                                       schoolId == null ||
//                                       selectedContentType == null) {
//                                     // Show error message if any of the required fields are null
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                           content: Text(
//                                               'Please fill out all the required fields.')),
//                                     );
//                                   } else {
//                                     // Only proceed if all required fields are not null
//                                     context.read<PostBloc>().add(CreatePost(
//                                           heading: _headingController.text,
//                                           body: _bodyController.text,
//                                           classId: selectedClassName!,
//                                           gradeId: selectedGradeName!,
//                                           schoolId: schoolId!,
//                                           contentType: selectedContentType!,
//                                           contentPictures: _images,
//                                           documents:
//                                               _documents, // Include documents
//                                         ));
//                                   }
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue, // Submit button color
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: state is PostLoading
//                               ? CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : Text('Submit',
//                                   style: TextStyle(color: Colors.white)),
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:bumblebee/bloc/Admin+Teacher/post/post_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/post/post_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/post/post_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/post_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For making HTTP requests

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostRepository postRepository = PostRepository();
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String? selectedClassName;
  String? selectedGradeName;
  List<String> classNames = [];
  List<String> gradeNames = [];
  String? selectedContentType;
  List<File> _images = []; // List to store multiple images
  List<File> _documents = []; // List to store selected documents
  final List<String> contentTypes = ['feed', 'announcement'];
  final ImagePicker _picker = ImagePicker();
  String? schoolId;
  String? schoolName;

  @override
  void initState() {
    super.initState();
    _fetchClassAndGradeNames(); // Fetch data when the screen initializes
    _fetchSchoolData();
  }

// Fetch school data (schoolId and schoolName)
  Future<void> _fetchSchoolData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    print('Token: $token'); // Debug: Check if token is retrieved

    if (token != null) {
      try {
        List<Map<String, dynamic>> schoolsData =
            await PostRepository.fetchSchoolData(token);
        print(
            'Fetched Schools Data: $schoolsData'); // Debug: Check fetched data

        // For example, if you want to get the first school only
        if (schoolsData.isNotEmpty) {
          setState(() {
            schoolId = schoolsData[0]["_id"]; // Or any other field
            schoolName = schoolsData[0]["schoolName"];
          });
        } else {
          print("No schools found.");
        }
      } catch (e) {
        print("Error fetching school data: $e");
      }
    } else {
      print("Token not found!");
    }
  }

  // Fetch class names and grade names
  Future<void> _fetchClassAndGradeNames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      if (token != null) {
        List<String> fetchedClassNames =
            await PostRepository.fetchClassNames(token);
        List<String> fetchedGradeNames =
            await PostRepository.fetchGradeNames(token);

        setState(() {
          classNames = fetchedClassNames;
          gradeNames = fetchedGradeNames;
        });
      } else {
        print("Token not found!");
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

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
      var status = await Permission.storage.status;
      if (status.isDenied) {
        await Permission.storage.request();
      }

      status = await Permission.photos.status;
      if (status.isDenied) {
        await Permission.photos.request();
      }

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
    if (selectedGradeName == null) {
      return 'Please select a grade';
    }
    if (selectedClassName == null) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post created successfully!')),
          );
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        } else if (state is PostFailure) {
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
                        value: selectedGradeName,
                        items: gradeNames.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedGradeName = newValue;
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
                        value: selectedClassName,
                        items: classNames.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedClassName = newValue;
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
                  maxLines: 2,
                ),
                SizedBox(height: 20),
                Center(
                  child: _images.isNotEmpty
                      ? Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _images
                              .map((image) => Image.file(image,
                                  height: 100, width: 100, fit: BoxFit.cover))
                              .toList(),
                        )
                      : TextButton.icon(
                          icon: Icon(Icons.photo, color: Colors.blue),
                          label: Text('Add Images',
                              style: TextStyle(color: Colors.blue)),
                          onPressed: _pickImage,
                        ),
                ),
                SizedBox(height: 20),
                Center(
                  child: _documents.isNotEmpty
                      ? Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _documents
                              .map((doc) => Text(doc.path.split('/').last))
                              .toList(),
                        )
                      : TextButton.icon(
                          icon: Icon(Icons.file_present, color: Colors.blue),
                          label: Text('Add Documents',
                              style: TextStyle(color: Colors.blue)),
                          onPressed: _pickDocuments,
                        ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final validationMessage = _validateForm();
                      if (validationMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(validationMessage)),
                        );
                        return;
                      }

                      // Get the SharedPreferences instance and retrieve the token
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('userToken') ??
                          ""; // Retrieve token here
                      print('selectedClassName: $selectedClassName');
                      print('selectedGradeName: $selectedGradeName');
                      print('schoolId: $schoolId');
                      print('selectedContentType: $selectedContentType');
                      // Check if any required fields are null
                      if (selectedClassName == null ||
                          selectedGradeName == null ||
                          schoolId == null ||
                          selectedContentType == null ||
                          token.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please fill all required fields.")),
                        );
                        return; // Early return to prevent the post creation
                      }

                      // Dispatch the event to create the post with all required parameters, including token
                      context.read<PostBloc>().add(CreatePost(
                            heading: _headingController.text,
                            body: _bodyController.text,
                            classId: selectedClassName!,
                            gradeId: selectedGradeName!,
                            schoolId: schoolId!,
                            contentType: selectedContentType!,
                            contentPictures: _images,
                            documents: _documents, // Include documents
                            //token: token, // Pass the token if needed
                          ));
                    },
                    child: Text('Create Post'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

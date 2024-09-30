import 'dart:io'; // Import for file handling
import 'package:equatable/equatable.dart'; // Optional for Equatable

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePost extends PostEvent {
  final String heading;
  final String? body;
  final String contentType;
  final String classId;
  final String schoolId;
  final File? contentPictures; // Add this for the image file

  CreatePost({
    required this.heading,
    this.body,
    required this.contentType,
    required this.classId,
    required this.schoolId,
    this.contentPictures, // Optionally pass an image file here
  });

  @override
  List<Object?> get props =>
      [heading, body, contentType, classId, schoolId, contentPictures];
}

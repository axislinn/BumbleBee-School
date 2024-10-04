import 'package:bumblebee/models/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts; // Adjust according to your data model

  PostLoaded({required this.posts});
}

class PostSuccess extends PostState {
  final List<PostModel> posts; // Add a field to store the list of posts

  PostSuccess(this.posts); // Update the constructor
}

class PostFailure extends PostState {
  final String error;

  PostFailure(this.error);
}

class PostError extends PostState {
  final String error;

  PostError(this.error);
}

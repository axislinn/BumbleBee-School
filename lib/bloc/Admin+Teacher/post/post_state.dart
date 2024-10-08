import 'package:bumblebee_school/models/Admin+Teacher/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostSuccess extends PostState {
  final List<PostModel> posts; // Add a field to store the list of posts

  PostSuccess(this.posts); // Update the constructor
}

class PostFailure extends PostState {
  final String error;

  PostFailure(this.error);
}

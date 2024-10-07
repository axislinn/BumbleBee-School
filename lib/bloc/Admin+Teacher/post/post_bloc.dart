import 'dart:io';
import 'package:bumblebee/bloc/Admin+Teacher/post/post_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/post/post_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/post_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    // Register event handlers
    on<CreatePost>(_onCreatePost);
    on<FetchPosts>(_onFetchPosts);
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    emit(PostLoading());

    try {
      // Retrieve token and schoolId from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');
      final schoolId = prefs.getString('schoolId');

      if (token == null || schoolId == null) {
        emit(PostFailure('Authentication token or School ID not found'));
        return;
      }

      // Convert List<File> to List<String> (file paths) for images and documents
      final List<String> imagePaths = event.contentPictures
          .map((image) => image.path)
          .toList(); // Convert to paths
      final List<String> documentPaths = event.documents
          .map((document) => document.path)
          .toList(); // Convert to paths

      // Create Post model with image paths
      final post = PostModel(
        heading: event.heading,
        body: event.body,
        contentType: event.contentType,
        classId: event.classId,
        schoolId: schoolId,
        contentPictures: imagePaths, // Now passing paths, not File objects
      );

      // Pass images and documents to the repository
      final result = await postRepository.createPost(
          post, schoolId, token, imagePaths, documentPaths);

      // Log response for debugging
      print("Post creation response: ${result}");

      // Check the result and emit appropriate state
      if (result.success) {
        emit(PostSuccess([]));
      } else {
        // Log the failure message in the console for debugging
        print("Failed to create post: ${result.message}");
        emit(PostFailure(result.message ?? 'Failed to create post'));
      }
    } catch (e) {
      // Log the caught error in the debug console
      print("An error occurred: $e");
      emit(PostFailure('An error occurred: $e'));
    }
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());

    try {
      // Retrieve token from SharedPreferences for authentication
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      // Fetch posts from the repository
      final List<PostModel> posts = await postRepository.fetchPosts(token);

      // Emit the loaded state with the fetched posts
      emit(PostSuccess(posts));
    } catch (e) {
      // Log the error for debugging
      print("An error occurred while fetching posts: $e");
      emit(PostFailure('An error occurred: $e'));
    }
  }
}

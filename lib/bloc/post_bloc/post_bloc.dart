import 'dart:io';
import 'package:bumblebee/bloc/post_bloc/post_event.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';
import 'package:bumblebee/models/post_model.dart';
import 'package:bumblebee/data/repository/repositories/post_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    // Register event handlers
    on<CreatePost>(_onCreatePost);
    on<FetchPosts>(_onFetchPosts); // Register FetchPostsEvent handler
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

      // Convert List<File> to List<String> for contentPictures and documents
      final List<String> imagePaths = event.contentPictures
          .map((image) => image.path)
          .toList(); // Convert List<File> to List<String>
      final List<String> documentPaths = event.documents
          .map((document) => document.path)
          .toList(); // Convert List<File> to List<String>

      // Create instances of School and Class using the data passed in the event
      final School school = School(id: schoolId, schoolName: event.schoolName);
      final Class classObj =
          Class(id: event.classId, className: event.className);

      // Create Post model with paths for images and documents
      final post = PostModel(
        heading: event.heading,
        body: event.body,
        contentType: event.contentType,
        classId: classObj, // Use Class object
        schoolId: school, // Use School object
        contentPictures: imagePaths, // Passing paths (List<String>)
        documents: documentPaths, // Passing document paths (List<String>)
      );

      // Call repository with List<String> for images and documents
      final result = await postRepository.createPost(
        post,
        schoolId,
        token,
        imagePaths, // Passing List<String> paths for images
        documentPaths, // Passing List<String> paths for documents
      );

      // Log response for debugging
      print("Post creation response: ${result}");

      // Check the result and emit appropriate state
      if (result.success) {
        emit(PostSuccess([])); // Emit success state
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

  /// Fetch data for posts
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

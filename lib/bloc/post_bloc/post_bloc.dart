import 'package:bumblebee/bloc/post_bloc/post_event.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';
import 'package:bumblebee/models/post_model.dart';
import 'package:bumblebee/data/repository/repositories/post_repository.dart'; // Ensure you import your repository
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    // Register event handlers
    on<CreatePost>(_onCreatePost);
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

      // Create Post model
      final post = PostModel(
        heading: event.heading,
        body: event.body,
        contentType: event.contentType,
        classId: event.classId,
        schoolId: schoolId,
      );

      // Call repository to create post
      final result = await postRepository.createPost(post, schoolId, token);

      // Log response for debugging
      print("Post creation response: ${result}");

      // Check the result and emit appropriate state
      if (result.success) {
        emit(PostSuccess());
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
}

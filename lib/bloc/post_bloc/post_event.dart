abstract class PostEvent {}

class CreatePost extends PostEvent {
  final String heading;
  final String? body;
  final String contentType;
  //final List<String>? reactions;
  final String classId;
  final String schoolId;

  CreatePost({
    required this.heading,
    required this.body,
    required this.contentType,
    //required this.reactions,
    required this.classId,
    required this.schoolId,
  });
}

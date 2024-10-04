import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';
import 'package:bumblebee/models/post_model.dart'; // Import the PostModel
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PostSuccess) {
          final posts = state.posts;

          if (posts.isEmpty) {
            return Center(child: Text('No posts available'));
          }

          // Render the list of posts using PostWidget
          return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostWidget(post: post); // Use PostWidget here
              });
        } else if (state is PostFailure) {
          return Center(child: Text('Failed to load posts: ${state.error}'));
        } else {
          return Center(child: Text('Unexpected error occurred.'));
        }
      },
    );
  }
}

// Your PostWidget class definition goes here

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile (posted_by)
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.postedBy!.profilePicture),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  post.postedBy!.userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // School ID (if available)
            if (post.schoolId.isNotEmpty)
              Text(
                'School ID: ${post.schoolId}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

            const SizedBox(height: 10),

            // Heading
            Text(
              post.heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Body (Post Content)
            if (post.body != null)
              Text(
                post.body!,
                style: const TextStyle(fontSize: 14),
              ),

            const SizedBox(height: 10),

            // Images (ContentPictures)
            if (post.contentPictures != null &&
                post.contentPictures!.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.contentPictures!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        post.contentPictures![index] as String,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 10),

            // Documents
            if (post.documents != null && post.documents!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attached Documents:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  ...post.documents!.map((doc) => GestureDetector(
                        onTap: () {
                          // Handle document tap to open/download
                        },
                        child: Text(
                          doc as String, // Show the document name or path
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )),
                ],
              ),

            const SizedBox(height: 10),

            // Reactions
            Row(
              children: [
                const Icon(Icons.thumb_up, size: 20, color: Colors.blue),
                const SizedBox(width: 5),
                Text('${post.reactions} Reactions'),
              ],
            ),

            const SizedBox(height: 10),

            // Date and Time
            Text(
              'Posted on: ${post.createdAt?.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (post.updatedAt != null)
              Text(
                'Updated on: ${post.updatedAt?.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}

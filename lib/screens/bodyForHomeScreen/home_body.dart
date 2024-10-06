import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';
import 'package:bumblebee/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

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

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostWidget(post: post);
            },
          );
        } else if (state is PostFailure) {
          return Center(child: Text('Failed to load posts: ${state.error}'));
        } else {
          return Center(child: Text('Unexpected error occurred.'));
        }
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the time using timeago for dynamic time display
    final formattedCreatedAt =
        post.createdAt != null ? timeago.format(post.createdAt!) : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section with School Name
            if (post.postedBy != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (post.postedBy!.profilePicture.isNotEmpty)
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(post.postedBy!.profilePicture),
                      radius: 20,
                    ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.postedBy?.userName ?? 'Anonymous',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      if (post.school?.schoolName != null)
                        Text(
                          post.school!.schoolName,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      if (post.postedBy?.userName != null)
                        Text(
                          'Admin: ${post.postedBy!.userName}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 10),

            // Time Display
            if (formattedCreatedAt != null)
              Text(
                'Posted $formattedCreatedAt',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            const SizedBox(height: 10),

            // Post Heading
            Text(
              post.heading,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Post Body
            if (post.body?.isNotEmpty ?? false)
              Text(
                post.body!,
                style: const TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 10),

            // Images (if any)
            if (post.contentPictures != null &&
                post.contentPictures!.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.contentPictures!.length,
                  itemBuilder: (context, index) {
                    final pictureUrl = post.contentPictures![index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: pictureUrl.isNotEmpty
                          ? Image.network(
                              pictureUrl,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),

            // Documents (if any)
            if (post.documents != null && post.documents!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attached Documents:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  ...post.documents!.map((doc) => GestureDetector(
                        onTap: () {
                          // Handle document click, e.g., open file
                        },
                        child: Text(
                          doc,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              decoration: TextDecoration.underline),
                        ),
                      )),
                ],
              ),
            const SizedBox(height: 10),

            // Like/Reaction Section
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up, color: Colors.blue),
                  onPressed: () {
                    // Handle like/reaction logic
                  },
                ),
                const SizedBox(width: 5),
                Text('${post.reactions ?? 0} Reactions'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

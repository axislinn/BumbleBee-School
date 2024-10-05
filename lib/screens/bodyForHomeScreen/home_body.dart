import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_bloc.dart';
import 'package:bumblebee/bloc/post_bloc/post_state.dart';
import 'package:intl/intl.dart';
import 'package:bumblebee/models/post_model.dart';

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
    final formattedCreatedAt = post.createdAt != null
        ? DateFormat.yMMMd().format(post.createdAt!.toLocal())
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.postedBy != null)
              Row(
                children: [
                  if (post.postedBy!.profilePicture.isNotEmpty)
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(post.postedBy!.profilePicture),
                      radius: 20,
                    ),
                  const SizedBox(width: 10),
                  Text(
                    post.postedBy?.userName ?? 'Anonymous',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Text(
              post.heading,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (post.body?.isNotEmpty ?? false)
              Text(
                post.body!,
                style: const TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 10),
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
            Row(
              children: [
                const Icon(Icons.thumb_up, size: 20, color: Colors.blue),
                const SizedBox(width: 5),
                Text('${post.reactions ?? 0} Reactions'),
              ],
            ),
            const SizedBox(height: 10),
            if (formattedCreatedAt != null)
              Text(
                'Posted on: $formattedCreatedAt',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}

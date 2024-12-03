import 'package:assigment/screens/post_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import '../bloc/post/post_state.dart';
import '../widgets/timer_widget.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                final isRead = state.readPosts.contains(post.id);
                final randomDuration = [10, 20, 25][index % 3];
                return ListTile(
                  title: Text(post.title),
                  tileColor: isRead ? Colors.white : Colors.lightBlueAccent,
                  trailing: TimerIcon(
                    duration: randomDuration,
                    onComplete: () {
                      print('Timer for post ${post.id} completed!');
                    },
                  ),
                  onTap: () {
                    context.read<PostBloc>().add(MarkPostAsRead(post.id));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(postId: post.id),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}

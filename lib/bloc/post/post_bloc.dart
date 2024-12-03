import 'package:assigment/bloc/post/post_event.dart';
import 'package:assigment/bloc/post/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

import '../../models/post_model.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    final postBox = Hive.box('postBox');

    on<FetchPosts>((event, emit) async {
      emit(PostLoading());
      try {
        final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as List;
          final posts = data.map((post) => Post.fromJson(post)).toList();

          final readPosts = postBox.get('readPosts', defaultValue: <int>[])?.toSet() ?? {};

          emit(PostLoaded(posts, readPosts));
        } else {
          emit(PostError('Failed to fetch posts.'));
        }
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });

    on<MarkPostAsRead>((event, emit) async {
      if (state is PostLoaded) {
        final currentState = state as PostLoaded;
        final updatedReadPosts = Set<int>.from(currentState.readPosts)..add(event.postId);

        postBox.put('readPosts', updatedReadPosts.toList());

        emit(PostLoaded(currentState.posts, updatedReadPosts));
      }
    });
  }
}
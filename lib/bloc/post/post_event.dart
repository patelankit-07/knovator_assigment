abstract class PostEvent {}

class FetchPosts extends PostEvent {}

class MarkPostAsRead extends PostEvent {
  final int postId;

  MarkPostAsRead(this.postId);
}
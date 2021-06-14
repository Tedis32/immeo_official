class Post {
  final int userid;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userid,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userid: json['userid'] as int,
      body: json['body'] as String,
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }

  String toString() {
    return "title: $title, userid: $userid, id: $id";
  }
}

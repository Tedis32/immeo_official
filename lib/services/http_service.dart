import 'dart:convert';

import 'package:http/http.dart';
import 'package:scan_in/entities/Post.dart';

class HTTPService {
  // TODO: Replace with functional API
  final String postsUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Post>> getPosts() async {
    print("Getting Posts ...");
    Response res = await get(Uri.parse(postsUrl));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Post> posts =
          body.map((dynamic item) => Post.fromJson(item)).toList();
      return posts;
    } else {
      throw "Can't get posts";
    }
  }
}

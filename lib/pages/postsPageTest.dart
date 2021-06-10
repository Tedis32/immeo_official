import 'package:flutter/material.dart';
import 'package:scan_in/entities/Post.dart';
import 'package:scan_in/services/http_service.dart';

class PostsPage extends StatelessWidget {
  final HTTPService httpService = HTTPService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpService.getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            List<Post>? posts = snapshot.data;

            return ListView(
                children: posts!
                    .map(
                      (Post post) => ListTile(title: Text(post.title)),
                    )
                    .toList());
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },);
  }
}

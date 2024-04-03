
import 'package:firebase_database/firebase_database.dart';

import '../model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static final _firestore = FirebaseFirestore.instance;

  static String folder_posts = "posts";

  static Future<Post> storePost(Post post) async {
    String postId = _firestore.collection(folder_posts).doc().id;
    await _firestore.collection(folder_posts).doc(postId).set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];

    var querySnapshot = await _firestore.collection(folder_posts).get();

    for (var result in querySnapshot.docs) {
      posts.add(Post.fromJson(result.data()));
    }
    return posts;
  }
}
// class RTDBService {
//   static final _database = FirebaseDatabase.instance.reference();
//
//   static Future<void> addPost(Post post) async {
//     await _database.child("posts").push().set(post.toJson());
//   }
//
//   static Future<List<Post>> getPosts(String id) async {
//     List<Post> items = [];
//     Query _query = _database.child("posts").orderByChild("userId").equalTo(id);
//     var snapshot = await _query.once();
//     var result = snapshot as Map<dynamic, dynamic>;
//
//     result.forEach((key, value) {
//       items.add(Post.fromJson(value));
//     });
//
//     return items;
//   }
// }

import 'package:flutter/material.dart';
import 'package:ngdemo16_fairbace/pages/detail_page.dart';
import '../model/post_model.dart';
import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/rtdb_service.dart';

class HomePage extends StatefulWidget {
  static final String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  var isLoading = false;
  List<Post> posts = [];
  late var items = <Post>[]; // Initialize items as a list of Post objects

  @override
  void initState() {
    super.initState();
    _apiGetPosts();
  }

  // Method to navigate to the detail page and handle returned data
  _openDetail() async {
    Map results = await Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) {
        return new DetailPage();
      },
    ));
    if (results != null && results.containsKey("data")) {
      print(results['data']);
      _apiGetPosts();
    }
  }

  // Method to fetch posts from the database
  _apiGetPosts() async {
    setState(() {
      isLoading = true;
    });
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((List<Post> fetchedPosts) {
      _respPosts(fetchedPosts);
    });
  }

  // Method to update the UI with fetched posts
  _respPosts(List<Post> fetchedPosts) {
    setState(() {
      isLoading = false;
      items = fetchedPosts; // Assign fetchedPosts to items
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("All Posts")),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOutUser(context);
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length, // Use items.length instead of items.l
            itemBuilder: (ctx, i) {
              return itemOfList(items[i]); // Access items[i]
            },
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Method to build the item widget for the ListView
  Widget itemOfList(Post post) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            child: post.img_url != null
                ? Image.network(
              post.img_url,
              fit: BoxFit.cover,
            )
                : Image.asset("assets/images/ic_default.png"),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                post.content,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
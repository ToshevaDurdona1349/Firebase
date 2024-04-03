import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngdemo16_fairbace/services/prefs_service.dart';
import 'package:ngdemo16_fairbace/services/utils_service.dart';

import '../model/post_model.dart';
import '../services/file_service.dart';
import '../services/rtdb_service.dart';

class DetailPage extends StatefulWidget {
  static final String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var isLoading = false;
  // rasmni import qiladi
  File? _image;
  final picker = ImagePicker();

  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _addNewPost() async {
    String title = titleController.text.toString().trim();
    String content = contentController.text.toString().trim();
    if(_image ==null){
      Utils.fireToast("Please select an image from your gallery");
      return;
    }
    String img_url = "";
    String userId = await Prefs.loadUserId();
    Post post = Post(userId, title, content, img_url);
    _apiUploadImage(post);
  }
//post yaratilganda rasmni upload qiladi
  void _apiUploadImage(Post post) async {
    setState(() {
      isLoading = true;
    });
    String img_url = await FileService.uploadPostImage(_image!);
    post.img_url = img_url;

    _apiAddPost(post);
  }
  _apiAddPost(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DBService.storePost(post);

    _backToFinish();
  }

  _backToFinish() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop(true);
  }

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Add Post",style: TextStyle(color: Colors.white),),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    //rasmchiqarib beradi
                    GestureDetector(
                      onTap: _getImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        child: _image != null
                            ? Image.file(_image!, fit: BoxFit.cover)
                            : Image.asset("assets/images/ic_camera.png"),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        hintText: "Content",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: MaterialButton(
                        onPressed: _addNewPost,
                        color: Colors.blue,
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
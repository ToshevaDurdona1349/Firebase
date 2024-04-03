import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

// class StoreService {
//   static final _storage = FirebaseStorage.instance.ref();
//   static final folder = "post_images";
//
//   static Future<String?> uploadImage(File _image) async {
//     String img_name = "image_" + DateTime.now().toString();
//     StorageReference firebaseStorageRef = _storage.child(folder).child(img_name);
//     StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
//     StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//     if (taskSnapshot != null) {
//       final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//       print(downloadUrl);
//       return downloadUrl;
//     }
//     return null;
//   }
// }
class StoreService {
  static final _storage = FirebaseStorage.instance;
  static final folder = "post_images";

  static Future<String?> uploadImage(File _image) async {
    String img_name = "image_" + DateTime.now().toString();
    Reference firebaseStorageRef = _storage.ref().child(folder).child(img_name);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    try {
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
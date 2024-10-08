// ignore_for_file: empty_constructor_bodies

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService() {}
  Future<String?> uploadUserpfp(
      {required File file, required String uid}) async {
    Reference fileRef =
        _firebaseStorage
        .ref('users/pfps')
        .child('$uid${file.path}');

    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }

  Future<String?> uploadImagetoChat(
      {required File file, required String chatID}) async {
    Reference fileRef = _firebaseStorage
        .ref('chats/$chatID')
        .child('${DateTime.now().toIso8601String()}${(file.path)}');
    UploadTask task = fileRef.putFile(file);
         return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }
}

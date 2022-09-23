import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudStorageAPI {

  final FirebaseStorage _db = FirebaseStorage.instance;
  UploadTask? uploadTask;

  Future<String> uploadImage(File image) async {
    final path = 'files/${UniqueKey()}';

    final storageRef = _db.ref().child(path);
    uploadTask = storageRef.putFile(image);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }
}
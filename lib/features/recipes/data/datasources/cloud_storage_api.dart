import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CloudStorageAPI {
  final FirebaseStorage _db = FirebaseStorage.instance;
  UploadTask? uploadTask;

  Future<String> uploadImage(File image) async {
    // Procesar la imagen en un hilo separado
    final processedImage = await compute(_processImage, image);

    final path = 'files/${UniqueKey()}';
    final storageRef = _db.ref().child(path);

    // Subir la imagen procesada
    uploadTask = storageRef.putFile(processedImage);
    final snapshot = await uploadTask!.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
}

// Función para procesar la imagen en un hilo separado
File _processImage(File image) {
  // Aquí puedes agregar lógica de procesamiento de imagen si es necesario
  return image;
}

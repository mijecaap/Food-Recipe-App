import 'dart:io';
import '../datasources/cloud_storage_api.dart';

class CloudStorageRepository {
  final _cloudStorageApi = CloudStorageAPI();

  Future<String> uploadRecipeImage(File image) =>
      _cloudStorageApi.uploadImage(image);
}

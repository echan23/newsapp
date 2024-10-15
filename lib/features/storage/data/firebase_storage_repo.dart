import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:newsapp2/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  /*

  Profile pictures - upload to storage

  */

  Future<String?> uploadProfileImageMobile(
      String? path, String fileName) async {
    // Check if the path is null
    if (path == null) {
      print('No file path provided');
      return null;
    }
    return await _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  /*
  Post images - upload images to storage
  */

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  //Helper methods

  // Upload a file to Firebase Storage and get its download URL
  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      // Get the file from the provided path
      final file = File(path);

      // Get a reference to the storage location
      final storageRef = storage.ref().child('$folder/$fileName');

      // Upload the file and wait for the task to complete
      final uploadTask = await storageRef.putFile(file);

      // Get the download URL after the upload completes
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      print('File uploaded successfully! Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }

  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, fileName, String folder) async {
    try {
      // Get a reference to the storage location
      final storageRef = storage.ref().child('$folder/$fileName');

      // Upload the file and wait for the task to complete
      final uploadTask = await storageRef.putData(fileBytes);

      // Get the download URL after the upload completes
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      print('File uploaded successfully! Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }
}

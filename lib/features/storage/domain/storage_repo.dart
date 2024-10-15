import 'dart:typed_data';

abstract class StorageRepo {
  //Upload profile images on mobile platforms
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  //Upload profile imeages on web
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

  Future<String?> uploadPostImageMobile(String path, String fileName);

  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName);
}

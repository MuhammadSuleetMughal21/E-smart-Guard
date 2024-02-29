import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtil {
  static final _storage = FlutterSecureStorage();

  static Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}

// void someFunction() async {
//   String? userId = await StorageUtil.getUserId();
//   String? token = await StorageUtil.getToken();

//   // Use userId and token as needed
// }
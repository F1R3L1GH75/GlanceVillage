import 'package:glancefrontend/services/local_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ClaimDataService {
  static Future<String> getUserId() async {
    final userToken = await LocalStorage.getAuthToken();
    if (userToken != null) {
      final claims = JwtDecoder.decode(userToken);
      return claims['UserId'];
    } else {
      return Future.error("Token not found!");
    }
  }

  static Future<String> getUserName() async {
    final userToken = await LocalStorage.getAuthToken();
    if (userToken != null) {
      final claims = JwtDecoder.decode(userToken);
      return claims['UserName'];
    } else {
      return Future.error("Token not found!");
    }
  }

  static Future<String> getFirstName() async {
    final userToken = await LocalStorage.getAuthToken();
    if (userToken != null) {
      final claims = JwtDecoder.decode(userToken);
      return claims['FirstName'];
    } else {
      return Future.error("Token not found!");
    }
  }

  static Future<String> getLastName() async {
    final userToken = await LocalStorage.getAuthToken();
    if (userToken != null) {
      final claims = JwtDecoder.decode(userToken);
      return claims['LastName'];
    } else {
      return Future.error("Token not found!");
    }
  }

  static Future<String> getEmail() async {
    final userToken = await LocalStorage.getAuthToken();
    if (userToken != null) {
      final claims = JwtDecoder.decode(userToken);
      return claims['Email'];
    } else {
      return Future.error("Token not found!");
    }
  }

  static Future<String> getPhoneNumber() async {
    final userToken = await LocalStorage.getAuthToken();
    if (userToken != null) {
      final claims = JwtDecoder.decode(userToken);
      return claims['PhoneNumber'];
    } else {
      return Future.error("Token not found!");
    }
  }

  static Future<String> getRole() async {
    final userToken = await LocalStorage.getAuthToken();
    if (userToken != null) {
      final claims = JwtDecoder.decode(userToken);
      return claims['Role'];
    } else {
      return Future.error("Token not found!");
    }
  }
}
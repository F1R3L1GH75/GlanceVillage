import 'package:glancefrontend/services/local_storage.dart';

class ApiSettings {
  static const String baseUrl = "glance.sathiyaraman-m.com";

  static Future<Map<String, String>> getHeaders({bool addAuthToken = false}) async {
    final headers = {
      'Content-Type': 'application/json; x-api-version=1.0; charset=UTF-8',
    };
    if(addAuthToken == true) {
      final authToken = await LocalStorage.getAuthToken();
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }
    }
    return headers;
  }
}

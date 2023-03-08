import 'dart:async';
import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/models/auth/token_response.dart';
import 'package:glancefrontend/models/wrapper/value_result.dart';
import 'package:http/http.dart' as http_client;

class LoginService {
  static const String _baseUrl = "glance.sathiyaraman-m.com";//"""192.168.5.131";

  static Future<ValueResult<TokenResponse>> loginAsync(TokenRequest request) async {
    final response = await http_client.post(
      Uri.https(_baseUrl, 'api/v1/token'),
      body: jsonEncode(request),
      headers: {'Content-Type': 'application/json; x-api-version=1.0; charset=UTF-8'}
    );
    if(response.statusCode == 200) {
      //r body = jsonDecode(response.body);
      //return ValueResult<TokenResponse>(body['succeeded'] as bool, body['messages'] as List<String>, body['data'] as TokenResponse);
      //return ValueResult.of<TokenResponse>(response.body);
      final jsonBody = jsonDecode(response.body);
      TokenResponse? obj = JsonMapper.deserialize<TokenResponse>(jsonBody['data']);
      return ValueResult<TokenResponse>(succeeded: jsonBody['succeeded'], messages: List<String>.from(jsonBody['messages'] as List), data: obj);
      //final decorator = (tr) => tr.cast<TokenResponse>();
      //JsonMapper.registerValueDecorator<ValueResult<TokenResponse>>(decorator);
      //return JsonMapper.deserialize<ValueResult<TokenResponse>>(response.body)!;
    } else {
      throw Exception("Login Failed. Status Code : ${response.statusCode}");
    }
  }
}
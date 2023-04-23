import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class PanchayatResponse {
  /***
   * {
      "id": "39A6BE74-A769-E5D1-2DB0-BD49B8E33C27",
      "name": "Maduravasal",
      "code": "22",
      "blockId": "83EF6B42-D46F-D6C7-303E-1E2BF5A609C9"
    }
   */
  String? id = '';
  String? name = '';
  String? code = '';
  String? blockId = '';
}

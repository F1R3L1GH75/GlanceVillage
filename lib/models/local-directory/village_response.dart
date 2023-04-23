import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class VillageResponse {
  /**
   * {
        "id": "F5CE4728-F3DF-BED3-459C-54A474370711",
        "name": "Maduravasal",
        "code": "22",
        "panchayatId": "39A6BE74-A769-E5D1-2DB0-BD49B8E33C27"
      }
   */
  String? id = '';
  String? name = '';
  String? code = '';
  String? panchayatId = '';
}

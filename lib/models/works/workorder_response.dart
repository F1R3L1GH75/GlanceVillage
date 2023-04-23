import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class WorkOrderResponse {
  /**{
      "id": "22919c3b-f2d5-4c81-bc54-cd0cb30b61d8",
      "date": "2023-04-23T00:00:00",
      "location": "Maduravasal",
      "latitude": 32,
      "longitude": 64,
      "workId": "cf239757-f274-4a7c-9d3b-a67ec94a938b",
      "code": "cf239757-f274-4a7c-9d3b-a67ec94a938b/00001",
      "workName": "Maduravasal-Sunken Pond @ Maduravasal Eri Kalvai "
    } */
  String? id = '';
  DateTime? date;
  String? location = '';
  double? latitude = 0;
  double? longitude = 0;
  String? workId = '';
  String? code = '';
  String? workName = '';
}

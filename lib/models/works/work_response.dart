import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class WorkResponse {
  /**
   * {
      "id": "cf239757-f274-4a7c-9d3b-a67ec94a938b",
      "code": "W/2023/04/00001",
      "name": "Maduravasal-Sunken Pond @ Maduravasal Eri Kalvai ",
      "natureOfWork": "Water Conservation",
      "scopeOfWork": "Constr of Water Absorption Trench Trench for Comm",
      "isCompleted": false,
      "panchayat": "Maduravasal",
      "block": "Ellapuram",
      "district": "Tiruvallur",
      "state": "Tamil Nadu",
      "startDate": "2023-04-18T00:00:00",
      "endDate": "2023-04-19T00:00:00",
      "location": "Maduravasal",
      "estimatedDuration": 4,
      "estimatedCost": 691000
    }
   */
  String? id = '';
  String? code = '';
  String? name = '';
  String? natureOfWork = '';
  String? scopeOfWork = '';
  bool isCompleted = false;
  String? panchayat = '';
  String? block = '';
  String? district = '';
  String? state = '';
  DateTime? startDate;
  DateTime? endDate;
  String? location = '';
  int estimatedDuration = 0;
  int estimatedCost = 0;
}

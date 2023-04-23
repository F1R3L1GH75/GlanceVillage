import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/local-directory/village_response.dart';
import 'package:glancefrontend/models/users/user_assigned_panchayats.dart';

class WorkFullResponse {
  /***
   * {
    "id": "cf239757-f274-4a7c-9d3b-a67ec94a938b",
    "code": "W/2023/04/00001",
    "name": "Maduravasal-Sunken Pond @ Maduravasal Eri Kalvai ",
    "natureOfWork": "Water Conservation",
    "scopeOfWork": "Constr of Water Absorption Trench Trench for Comm",
    "isCompleted": false,
    "villages": [
      {
        "id": "F5CE4728-F3DF-BED3-459C-54A474370711",
        "name": "Maduravasal",
        "code": "22",
        "panchayatId": "39A6BE74-A769-E5D1-2DB0-BD49B8E33C27"
      }
    ],
    "panchayat": {
      "id": "39A6BE74-A769-E5D1-2DB0-BD49B8E33C27",
      "name": "Maduravasal",
      "code": "22",
      "blockId": "83EF6B42-D46F-D6C7-303E-1E2BF5A609C9"
    },
    "block": {
      "id": "83EF6B42-D46F-D6C7-303E-1E2BF5A609C9",
      "name": "Ellapuram",
      "code": "1",
      "districtId": "0BA1F2DF-6345-EC0F-0284-61D1161941C5"
    },
    "district": {
      "id": "0BA1F2DF-6345-EC0F-0284-61D1161941C5",
      "name": "Tiruvallur",
      "code": "33",
      "stateId": "74a2dde2-90c5-4469-b4c9-25ab07365b93"
    },
    "state": {
      "id": "74a2dde2-90c5-4469-b4c9-25ab07365b93",
      "name": "Tamil Nadu",
      "code": "30"
    },
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
  @JsonProperty(name: 'villages')
  List<VillageResponse>? villages = [];
  PanchayatResponse? panchayat;
  BlockResponse? block;
  DistrictResponse? district;
  StateResponse? state;
  DateTime? startDate;
  DateTime? endDate;
  String? location = '';
  int estimatedDuration = 0;
  double estimatedCost = 0;
}

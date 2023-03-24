import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class UserAssignedPanchayats {
  String id = "";
  List<PanchayatResponse> panchayats = [];
}

@jsonSerializable
class PanchayatResponse {
  String id = "";
  String name = "";
  String code = "";
  BlockResponse block = BlockResponse();
  DistrictResponse district = DistrictResponse();
  StateResponse state = StateResponse();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'block': block,
        'district': district,
        'state': state,
      };
}

@jsonSerializable
class BlockResponse {
  String id = "";
  String name = "";
  String code = "";
  String districtId = "";

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'districtId': districtId,
      };
}

@jsonSerializable
class DistrictResponse {
  String id = "";
  String name = "";
  String code = "";
  String stateId = "";

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'stateId': stateId,
      };
}

@jsonSerializable
class StateResponse {
  String id = "";
  String name = "";
  String code = "";

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}

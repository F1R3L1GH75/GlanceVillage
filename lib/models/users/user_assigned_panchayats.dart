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
}

@jsonSerializable
class BlockResponse {
  String id = "";
  String name = "";
  String code = "";
  String districtId = "";
}

@jsonSerializable
class DistrictResponse {
  String id = "";
  String name = "";
  String code = "";
  String stateId = "";
}

@jsonSerializable
class StateResponse {
  String id = "";
  String name = "";
  String code = "";
}

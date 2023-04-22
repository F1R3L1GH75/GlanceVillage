import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class JobCardResponse {
  String? id = '';
  String? jobCardNumber = '';
  String? name = '';
  String? fatherOrHusbandName = '';
  String? aadhaarNumber = '';
  String? email = '';
  String? mobileNumber = '';
  DateTime dateOfBirth = DateTime.now();
  int yearOfBirth = 0;
  String? rationCardNumber = '';
  String? gende = '';
  String? category = '';
  String? address = '';
  String? village = '';
  String? villageId = '';
  String? panchayat = '';
  String? panchayatId = '';
  String? block = '';
  String? blockId = '';
  String? district = '';
  String? districtId = '';
  String? state = '';
  String? stateId = '';
  String? pinCode = '';
  String? createdBy = '';
  DateTime createdOn = DateTime.now();
  String? lastUpdatedBy = '';
  DateTime? lastUpdatedOn = null;
  bool isVerified = false;
  String? verifiedBy = '';
  String? verifiedOn = '';
}

import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class JobCardResponse {
  String id = '';
  String jobCardNumber = '';
  String name = '';
  String fatherOrHusbandName = '';
  String aadhaarNumber = '';
  String email = '';
  String mobileNumber = '';
  DateTime dateOfBirth = DateTime.now();
  int yearOfBirth = 0;
  String rationCardNumber = '';
  String gende = '';
  String category = '';
  String address = '';
  String village = '';
  String panchayat = '';
  String block = '';
  String district = '';
  String state = '';
  String pinCode = '';
  String createdBy = '';
  DateTime createdOn = DateTime.now();
  String? lastUpdatedBy = '';
  DateTime? lastUpdatedOn;
  bool isVerified = false;
  String? verifiedBy = '';
  String? verifiedOn = '';
}

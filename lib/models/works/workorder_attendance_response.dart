import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class WorkOrderAttendanceResponse {
  String? id;
  String? workOrderId;
  String? workOrderCode;
  String? jobCardId;
  String? jobCardCode;
  String? jobCardName;
  String? supervisorId;
  String? supervisorName;
  late DateTime inTime;
  DateTime? outTime;
  double? inLongitude;
  double? inLatitude;
  double? outLongitude;
  double? outLatitude;
}

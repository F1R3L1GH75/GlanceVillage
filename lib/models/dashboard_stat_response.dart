import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class DashboardStatResponse {
  late int totalVillagesInUserAssignedPanchayats = 0;
  late int totalJobCardsInUserAssignedPanchayats = 0;
  late int totalNewApplicationsThisYearInUserAssignedPanchayats = 0;
  late int totalOngoingWorksTodayInUserAssignedPanchayats = 0;
  late int totalWorkOrdersTodayInUserAssignedPanchayats = 0;
  late int totalAllottedWorkersTodayInUserAssignedPanchayats = 0;

}
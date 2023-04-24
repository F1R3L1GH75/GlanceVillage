import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/models/works/workorder_response.dart';
import 'package:glancefrontend/services/api/jobcard_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:geolocator/geolocator.dart';

class CreateWorkOrderAttendanceScreen extends StatelessWidget {
  const CreateWorkOrderAttendanceScreen({super.key, required this.workOrder});

  final WorkOrderResponse workOrder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _CreateWorkOrderAttendanceState(workOrder),
        builder: (context, child) {
          final provider =
              Provider.of<_CreateWorkOrderAttendanceState>(context);
          provider._handleLocationPermission(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('New Attendance'),
              backgroundColor: const Color(0xFF2661FA),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save_rounded),
                  onPressed: () {
                    provider.submitAsync(context);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.qr_code_scanner_rounded),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2661FA),
                                ),
                                onPressed: () {
                                  provider.scanQRCodeAsync(context);
                                },
                                label: const Text('SCAN EMPLOYEE')),
                          ),
                          Flexible(
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.person),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2661FA),
                                ),
                                onPressed: () {},
                                label: const Text('ENTER JOBCARD ID')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      provider.jobCard != null
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: const Text('JobCard ID'),
                                  subtitle:
                                      Text(provider.jobCard!.jobCardNumber!),
                                ),
                              ),
                            )
                          : const Text('No JobCard Selected'),
                    ],
                  )),
            ),
          );
        });
  }
}

class _CreateWorkOrderAttendanceState with ChangeNotifier {
  _CreateWorkOrderAttendanceState(this.workOrder);

  final WorkOrderResponse workOrder;

  JobCardResponse? _jobCard;
  JobCardResponse? get jobCard => _jobCard;
  set jobCard(JobCardResponse? value) {
    _jobCard = value;
    notifyListeners();
  }

  String? _jobCardId = '';
  String? get jobCardId => _jobCardId;
  set jobCardId(String? value) {
    _jobCardId = value;
    notifyListeners();
  }

  Future<void> submitAsync(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create Attendance From State Class'),
      ),
    );
  }

  Future<void> scanQRCodeAsync(BuildContext context) async {
    try {
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (result != PermissionStatus.granted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Camera permission is required')));
          }
        }
      }
      String? cameraScanResult = await scanner.scan();
      jobCardId = cameraScanResult;
      final response = await JobCardService.getJobCardByIdAsync(jobCardId!);
      if (response == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid JobCard ID')));
        }
      }
      jobCard = response;
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get platform version. $e')));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
      }
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }
      return false;
    }
    return true;
  }
}

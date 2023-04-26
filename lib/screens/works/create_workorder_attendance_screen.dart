import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/models/works/workorder_response.dart';
import 'package:glancefrontend/services/api/attendance_service.dart';
import 'package:glancefrontend/services/api/jobcard_service.dart';
import 'package:glancefrontend/services/api/user_service.dart';
import 'package:intl/intl.dart';
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
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: ElevatedButton.icon(
                                  icon:
                                      const Icon(Icons.qr_code_scanner_rounded),
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
                                  onPressed: () {
                                    provider.getJobCardNumber(context);
                                  },
                                  label: const Text('ENTER JOBCARD ID')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _LoadJobCardAndAttendanceForm()
                      ],
                    )),
              ),
            ),
          );
        });
  }
}

class _LoadJobCardAndAttendanceForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<_CreateWorkOrderAttendanceState>(context);
    if (provider.jobCard != null) {
      return Column(
        children: [
          Card(
            child: Column(
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Work Order Details',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: const Text('WorkOrder ID'),
                  trailing: Text(provider.workOrder.code!),
                ),
                ListTile(
                  title: const Text('Date/Time'),
                  trailing: Text(DateFormat("dd-MM-yyyy hh:mm:ss aa")
                      .format(DateTime.now())),
                ),
                ListTile(
                  title: const Text('Name'),
                  subtitle: Text(provider.workOrder.workName!),
                ),
              ],
            ),
          ),
          provider.verifiedJobCard
              ? MaterialButton(
                  onPressed: () {},
                  enableFeedback: false,
                  child: const Text('Job Card Verified'))
              : ElevatedButton.icon(
                  onPressed: () {
                    provider.verifyJobCardFingerPrint(context);
                  },
                  label: const Text('Verify JobCard'),
                  icon: const Icon(Icons.fingerprint_rounded),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2661FA),
                  ),
                ),
          Card(
            child: Column(
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'JobCard Details',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: const Text('JobCard ID'),
                  trailing: Text(provider.jobCard!.jobCardNumber!),
                ),
                ListTile(
                  title: const Text('Name'),
                  trailing: Text(provider.jobCard!.name!),
                ),
                ListTile(
                  title: const Text('Father/Husband Name'),
                  trailing:
                      Text(provider.jobCard!.fatherOrHusbandName ?? "N/A"),
                ),
                ListTile(
                  title: const Text('Mobile'),
                  trailing: Text(provider.jobCard!.mobileNumber ?? "N/A"),
                ),
                ListTile(
                  title: const Text('Email'),
                  trailing: Text(provider.jobCard!.email ?? "N/A"),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return const Text('No JobCard Selected');
    }
  }
}

class _CreateWorkOrderAttendanceState with ChangeNotifier {
  static const fingerPrintChannel =
      MethodChannel('com.firelights.glance/fingerprint');

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

  String? _jobCardNumber = '';
  String? get jobCardNumber => _jobCardNumber;
  set jobCardNumber(String? value) {
    _jobCardNumber = value;
    notifyListeners();
  }

  bool verifiedJobCard = false;

  Future<void> submitAsync(BuildContext context) async {
    if (await Geolocator.isLocationServiceEnabled()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location Services are not enabled!'),
          ),
        );
      }
    }
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content:
                const Text('Are you sure you want to create this attendance?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2661FA),
                  ),
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2661FA),
                  ),
                  child: const Text('OK'))
            ],
          );
        },
      );
    }
    final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // final response = await AttendanceService.markAttendanceIn(
    //     jobCardId!, workOrder.workOrderId!, location);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marked Attendance Successfully!'),
        ),
      );
    }
  }

  Future<void> getJobCardNumber(BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          final TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: const Text('Enter Job Card Number'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Job Card Number'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2661FA),
                  ),
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    jobCardNumber = controller.text;
                    Navigator.pop(context, controller.text);
                    final response =
                        await JobCardService.getJobCardByCardNumber(
                            jobCardNumber!);
                    if (response == null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid JobCard ID')));
                      }
                    }
                    jobCard = response;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2661FA),
                  ),
                  child: const Text('OK'))
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'))
            ],
          );
        },
      );
    }
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
      if (jobCardId != null) {
        final response = await JobCardService.getJobCardByIdAsync(jobCardId!);
        if (response == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid JobCard ID')));
          }
        }
        jobCard = response;
      }
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

  Future verifyJobCardFingerPrint(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Verify JobCard Fingerprint'),
              content: const Text(
                  'Ask the JobCard holder to place his/her finger on the scanner'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      return;
                    },
                    child: const Text('Cancel'))
              ]);
        },
        barrierDismissible: false);
    final fingerBytes = await JobCardService.getJobCardByIdAsync(jobCardId!);
    try {
      final success = await fingerPrintChannel.invokeMethod(
          'verifyFingerprint', fingerBytes);
      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint verification successful!'),
            ),
          );
          Navigator.pop(context);
        }
        verifiedJobCard = true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint verification failed!'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future verifyUserFingerPrint(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Authenticate User Fingerprint'),
              content: const Text('Place your finger on the scanner'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      return;
                    },
                    child: const Text('Cancel'))
              ]);
        },
        barrierDismissible: false);
    final fingerBytes = await UserService.getFingerprint();
    try {
      final success = await fingerPrintChannel.invokeMethod(
          'verifyFingerprint', fingerBytes);
      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint verification successful!'),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint verification failed!'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }
}

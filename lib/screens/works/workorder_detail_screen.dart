import 'package:flutter/material.dart';
import 'package:glancefrontend/extensions/datetime_extensions.dart';
import 'package:glancefrontend/models/works/work_full_response.dart';
import 'package:glancefrontend/models/works/workorder_response.dart';
import 'package:glancefrontend/screens/works/create_workorder_attendance_screen.dart';
import 'package:glancefrontend/screens/works/workorder_attendances_screen.dart';
import 'package:glancefrontend/services/api/work_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkOrderDetailScreen extends StatelessWidget {
  const WorkOrderDetailScreen({super.key, required this.workOrder});

  final WorkOrderResponse workOrder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _WorkOrderDetailScreenState(workOrder),
        builder: (context, child) {
          final provider = Provider.of<_WorkOrderDetailScreenState>(context);
          if (provider.isLoading == true) {
            return Scaffold(
              appBar: AppBar(
                title: Text(workOrder.code!),
                backgroundColor: const Color(0xFF2661FA),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (provider.isError == true) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(workOrder.code!),
                  backgroundColor: const Color(0xFF2661FA),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Error: ${provider.errorMessage}'),
                      MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: const Color(0xFF2661FA),
                          textColor: Colors.white,
                          child: const Text('Go Back'))
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(workOrder.code!),
                  backgroundColor: const Color(0xFF2661FA),
                ),
                body: SafeArea(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 12),
                        child: Center(
                          child: Text(
                            'Work Order Date: ${DateFormat('dd/MM/yyyy').format(workOrder.date!)}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.open_in_new),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF2661FA))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WorkOrderAttendanceScreen(
                                          workOrder: workOrder)));
                        },
                        label: const Text('VIEW ATTENDANCES'),
                      ),
                      Card(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 16),
                        child: ListTile(
                            title: const Text('Work Order Code'),
                            trailing: Text(workOrder.code!)),
                      ),
                      Card(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: ListTile(
                            title: const Text('Work Code'),
                            trailing: Text(provider.work!.code!)),
                      ),
                      Card(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: ListTile(
                            title: const Text('Work Name'),
                            subtitle: Text(workOrder.workName!)),
                      ),
                      Card(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: ListTile(
                            title: const Text('Location'),
                            trailing: Text(workOrder.location!)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Card(
                              margin: const EdgeInsets.only(
                                  left: 8, right: 4, top: 8),
                              child: ListTile(
                                  title: const Text('Latitude'),
                                  trailing:
                                      Text(workOrder.latitude.toString())),
                            ),
                          ),
                          Flexible(
                              child: Card(
                            margin: const EdgeInsets.only(
                                left: 4, right: 8, top: 8),
                            child: ListTile(
                                title: const Text('Longitude'),
                                trailing: Text(workOrder.longitude.toString())),
                          ))
                        ],
                      ),
                      //     ]);
                      //   },
                      // )
                    ],
                  ),
                )),
                floatingActionButton: workOrder.date!.isSameDate(DateTime.now())
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateWorkOrderAttendanceScreen(
                                          workOrder: workOrder)));
                        },
                        backgroundColor: const Color(0xFF2661FA),
                        child: const Icon(Icons.add),
                      )
                    : null,
              );
            }
          }
        });
  }
}

class _WorkOrderDetailScreenState with ChangeNotifier {
  _WorkOrderDetailScreenState(this.workOrder) {
    getWork();
  }

  final WorkOrderResponse workOrder;
  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';

  WorkFullResponse? work;

  Future<void> getWork() async {
    isLoading = true;
    isError = false;
    errorMessage = '';
    notifyListeners();
    try {
      work = await WorkService.getByIdAsync(workOrder.workId!);
      isError = false;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    }
    notifyListeners();
    isLoading = false;
  }
}

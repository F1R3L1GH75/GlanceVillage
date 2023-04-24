import 'package:flutter/material.dart';
import 'package:glancefrontend/models/works/workorder_attendance_response.dart';
import 'package:glancefrontend/models/works/workorder_response.dart';
import 'package:glancefrontend/services/api/work_service.dart';
import 'package:provider/provider.dart';

class WorkOrderAttendanceScreen extends StatelessWidget {
  const WorkOrderAttendanceScreen({super.key, required this.workOrder});

  final WorkOrderResponse? workOrder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _WorkOrderAttendanceState(workOrder),
        builder: (context, child) {
          final provider = Provider.of<_WorkOrderAttendanceState>(context);
          if (provider.isLoading == true) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Work Order Attendance'),
                backgroundColor: const Color(0xFF2661FA),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (provider.isError) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Work Order Attendance'),
                  backgroundColor: const Color(0xFF2661FA),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Error: ${provider.errorMessage}',
                          textAlign: TextAlign.center),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2661FA),
                          ),
                          child: const Text('GO BACK'))
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Work Order Attendance'),
                  backgroundColor: const Color(0xFF2661FA),
                ),
                body: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: provider.workOrderAttendances.isNotEmpty
                          ? ListView.builder(
                              itemCount: provider.workOrderAttendances.length,
                              itemBuilder: (context, index) {
                                final workOrderAttendance =
                                    provider.workOrderAttendances[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                        'Employee: ${workOrderAttendance.jobCardName!} ${workOrderAttendance.jobCardCode!}'),
                                    subtitle: Text(
                                        'Attendance: ${workOrderAttendance.outTime != null ? 'IN' : 'OUT'}'),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                  'No Work Order Attendances recorded so far'),
                            )),
                ),
              );
            }
          }
        });
  }
}

class _WorkOrderAttendanceState with ChangeNotifier {
  int _pageNumber = 1;
  int get pageNumber => _pageNumber;
  void setPageNumber(int page) {
    _pageNumber = page;
    getWorkOrderAttendance();
    notifyListeners();
  }

  final int _pageSize = 10;
  int get pageSize => _pageSize;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  void setSearchQuery(String query) {
    _searchQuery = query;
    getWorkOrderAttendance();
    notifyListeners();
  }

  List<WorkOrderAttendanceResponse> _workOrderAttendances = [];
  List<WorkOrderAttendanceResponse> get workOrderAttendances =>
      _workOrderAttendances;

  final WorkOrderResponse? workOrder;

  _WorkOrderAttendanceState(this.workOrder) {
    getWorkOrderAttendance();
  }

  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';

  void getWorkOrderAttendance() async {
    try {
      isLoading = true;
      isError = false;
      errorMessage = '';
      notifyListeners();
      final response = await WorkService.getAllWorkOrderAttendance(
          workOrder!.id!, pageNumber, pageSize, searchQuery);
      _workOrderAttendances = response;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
      _workOrderAttendances = [];
    }
    isLoading = false;
    notifyListeners();
  }
}

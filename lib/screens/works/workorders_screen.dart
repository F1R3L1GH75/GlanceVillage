import 'package:flutter/material.dart';
import 'package:glancefrontend/models/works/workorder_response.dart';
import 'package:glancefrontend/screens/works/workorder_detail_screen.dart';
import 'package:glancefrontend/services/api/work_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkOrdersScreen extends StatelessWidget {
  const WorkOrdersScreen(
      {super.key, required this.workId, required this.workCode});

  final String? workId;
  final String? workCode;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _WorkOrderScreenState(workId),
        builder: (context, child) {
          final provider = Provider.of<_WorkOrderScreenState>(context);
          if (provider.isLoading == true) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Work Orders: $workCode'),
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
                  title: Text('Work Orders: $workCode'),
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
                  title: Text('Work Orders: $workCode'),
                  backgroundColor: const Color(0xFF2661FA),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: provider.workOrders!.length,
                    itemBuilder: (context, index) {
                      final workOrder = provider.workOrders![index];
                      return Card(
                        child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => WorkOrderDetailScreen(
                                          workOrder: workOrder)));
                            },
                            title: Text(DateFormat('dd/MM/yyyy')
                                .format(workOrder.date!)),
                            subtitle: Text(
                                '${workOrder.workName!}, ${workOrder.location!}'),
                            trailing: workOrder.date!.isSameDate(DateTime.now())
                                ? const Icon(Icons.construction,
                                    color: Colors.grey)
                                : const Icon(Icons.check_circle,
                                    color: Colors.green)),
                      );
                    },
                  ),
                ),
              );
            }
          }
        });
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class _WorkOrderScreenState with ChangeNotifier {
  int _pageNumber = 1;
  int get pageNumber => _pageNumber;
  void setPageNumber(int page) {
    _pageNumber = page;
    getWorkOrders();
    notifyListeners();
  }

  final int _pageSize = 10;
  int get pageSize => _pageSize;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  void setSearchQuery(String query) {
    _searchQuery = query;
    getWorkOrders();
    notifyListeners();
  }

  _WorkOrderScreenState(this.workId) {
    getWorkOrders();
  }

  final String? workId;
  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';
  List<WorkOrderResponse>? workOrders;

  Future<void> getWorkOrders() async {
    try {
      isLoading = true;
      isError = false;
      errorMessage = '';
      notifyListeners();
      final response = await WorkService.getWorkOrders(
          workId!, pageNumber, pageSize, searchQuery);
      workOrders = response;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}

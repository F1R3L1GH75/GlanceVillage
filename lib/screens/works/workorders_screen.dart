import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glancefrontend/extensions/datetime_extensions.dart';
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
                floatingActionButton: provider.canAddWorkOrder
                    ? FloatingActionButton(
                        onPressed: () {
                          provider.createWorkOrder(context);
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

  bool _canAddWorkOrder = false;
  bool get canAddWorkOrder => _canAddWorkOrder;

  String _location = '';
  String get location => _location;

  Future<void> getWorkOrders() async {
    try {
      isLoading = true;
      isError = false;
      errorMessage = '';
      notifyListeners();
      final response = await WorkService.getWorkOrders(
          workId!, pageNumber, pageSize, searchQuery);
      workOrders = response;
      if (workOrders!.any((e) => e.date!.isSameDate(DateTime.now()))) {
        _canAddWorkOrder = false;
      } else {
        _canAddWorkOrder = true;
      }
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createWorkOrder(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Expanded(child: Text('Creating Work Order...'))
              ],
            ));
          },
          barrierDismissible: false);
      if (await Geolocator.isLocationServiceEnabled() == false) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location Services are not enabled!'),
            ),
          );
          return;
        }
      }
      if (context.mounted) {
        final locationAccepted = await getLocationName(context);
        if (locationAccepted == false) {
          return;
        }
      }
      final geoLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await WorkService.createWorkOrder(
          location, geoLocation.latitude, geoLocation.longitude, workId!);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Work Order Created!'),
          ),
        );
      }
      _canAddWorkOrder = false;
      getWorkOrders();
      notifyListeners();
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

  Future<bool> getLocationName(BuildContext context) async {
    bool result = false;
    await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Location Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Location Name'),
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
                onPressed: () {
                  _location = controller.text;
                  result = true;
                  Navigator.pop(context, controller.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2661FA),
                ),
                child: const Text('OK'))
          ],
        );
      },
    );
    return result;
  }
}

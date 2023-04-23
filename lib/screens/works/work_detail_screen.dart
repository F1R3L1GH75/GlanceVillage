import 'package:flutter/material.dart';
import 'package:glancefrontend/models/works/work_full_response.dart';
import 'package:glancefrontend/models/works/work_response.dart';
import 'package:glancefrontend/screens/works/workorders_screen.dart';
import 'package:glancefrontend/services/api/work_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkDetailScreen extends StatelessWidget {
  const WorkDetailScreen({super.key, required this.workId});

  final String? workId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkDetailScreenState>(
        create: (context) => WorkDetailScreenState(workId),
        builder: (context, child) {
          final provider = Provider.of<WorkDetailScreenState>(context);
          final work = provider.work;
          if (provider.isLoading == false) {
            if (provider.isError == true) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Work Detail: Error'),
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
                  title: Text('Work: ${work!.code ?? 'Loading'}'),
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
                              '${work.name}',
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
                                    builder: (_) => WorkOrdersScreen(
                                        workId: work.id, workCode: work.code)));
                          },
                          label: const Text('VIEW WORK ORDERS'),
                        ),
                        Card(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 16),
                          child: ListTile(
                              title: const Text('Nature of Work'),
                              subtitle: Text('${work.natureOfWork}')),
                        ),
                        Card(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: ListTile(
                              title: const Text('Scope of Work'),
                              subtitle: Text('${work.scopeOfWork}')),
                        ),
                        Card(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 8),
                            child: ListTile(
                              title: const Text('Work Completion Status'),
                              trailing: work.isCompleted == true
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : const Icon(Icons.construction),
                            )),
                        Card(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: ListTile(
                              title: const Text('Start Date '),
                              trailing: Text(DateFormat('dd/MM/yyyy')
                                  .format(work.startDate!))),
                        ),
                        Card(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: ListTile(
                              title: const Text('End Date '),
                              trailing: Text(DateFormat('dd/MM/yyyy')
                                  .format(work.endDate!))),
                        ),
                        Card(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: ListTile(
                              title: const Text('Villages'),
                              subtitle: Text(work.villages!
                                  .map((element) => element.name)
                                  .join(', '))),
                        ),
                        Card(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: ListTile(
                              title: const Text('Location'),
                              subtitle: Text('${work.panchayat!.name}, '
                                  '${work.block!.name}, '
                                  '${work.district!.name}, ${work.state!.name}')),
                        ),
                        Card(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: ListTile(
                              title: const Text('Estimated Cost'),
                              subtitle: Text('Rs.${work.estimatedCost}')),
                        ),
                        Card(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: ListTile(
                              title: const Text('Estimated Duration'),
                              subtitle:
                                  Text('${work.estimatedDuration} Months')),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Work Detail: Loading'),
                backgroundColor: const Color(0xFF2661FA),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class WorkDetailScreenState with ChangeNotifier {
  WorkFullResponse? _work;
  WorkFullResponse? get work => _work;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isError = false;
  bool get isError => _isError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final String? workId;

  WorkDetailScreenState(this.workId) {
    _isLoading = true;
    getWorkByIdAsync();
  }

  Future<void> getWorkByIdAsync() async {
    _isLoading = true;
    _isError = false;
    _errorMessage = '';
    try {
      final work = await WorkService.getByIdAsync(workId!);
      _work = work;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _isError = true;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}

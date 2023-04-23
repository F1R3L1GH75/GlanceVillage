import 'package:flutter/material.dart';
import 'package:glancefrontend/models/works/work_full_response.dart';
import 'package:glancefrontend/models/works/work_response.dart';
import 'package:glancefrontend/services/api/work_service.dart';
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
                  centerTitle: true,
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
                  centerTitle: true,
                  title: Text('Work: ${work!.code ?? 'Loading'}'),
                  backgroundColor: const Color(0xFF2661FA),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.only(
                              left: 12, right: 12, top: 12),
                          child: ListTile(
                              title: const Text('Work Name'),
                              subtitle: Text('${work.name}')),
                        ),
                        Card(
                          margin: const EdgeInsets.only(
                              left: 12, right: 12, top: 12),
                          child: ListTile(
                              title: const Text('Nature of Work'),
                              subtitle: Text('${work.natureOfWork}')),
                        ),
                        Card(
                          margin: const EdgeInsets.only(
                              left: 12, right: 12, top: 12),
                          child: ListTile(
                              title: const Text('Scope of Work'),
                              subtitle: Text('${work.scopeOfWork}')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Card(
                                  child: ListTile(
                                title: Text('Work Status'),
                                subtitle: Text('Completed'),
                              )),
                              Card(
                                  child: ListTile(
                                title: Text('Work Progress'),
                                subtitle: Text('100%'),
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
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

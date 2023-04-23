import 'package:flutter/material.dart';
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
                    children: [
                      provider.isError
                          ? const Text('Error')
                          : const Text('Work Detail Screen'),
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
                  title: Text('Work Code: ${work!.code ?? 'Loading'}'),
                  backgroundColor: const Color(0xFF2661FA),
                ),
                body: const Center(
                  child: Text('Work Detail Screen'),
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Work Detail: Loading'),
                backgroundColor: Color(0xFF2661FA),
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
  WorkResponse? _work;
  WorkResponse? get work => _work;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isError = false;
  bool get isError => _isError;

  final String? workId;

  WorkDetailScreenState(this.workId) {
    _isLoading = true;
    getWorkByIdAsync();
  }

  Future<void> getWorkByIdAsync() async {
    _isLoading = true;
    _isError = false;
    try {
      final work = await WorkService.getByIdAsync(workId!);
      _work = work;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _isError = true;
    }
    notifyListeners();
  }
}

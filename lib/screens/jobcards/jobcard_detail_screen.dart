import 'package:flutter/material.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/screens/jobcards/jobcard_detailed_screen.dart';
import 'package:glancefrontend/services/api/jobcard_service.dart';
import 'package:provider/provider.dart';

class JobCardDetailScreen extends StatelessWidget {
  const JobCardDetailScreen({super.key, required this.jobCardId});

  final String? jobCardId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_JobCardDetailScreenState>(
      create: (_) => _JobCardDetailScreenState(jobCardId),
      builder: (context, child) {
        final provider = Provider.of<_JobCardDetailScreenState>(context);
        final jobCard = provider.jobCard;
        if (provider._isLoading == false) {
          if (provider.isError == true) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Job Card Detail: Error'),
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
            return JobCardDetailedScreen(jobCard: jobCard!);
          }
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Job Card Detail: Loading'),
              backgroundColor: const Color(0xFF2661FA),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class _JobCardDetailScreenState with ChangeNotifier {
  JobCardResponse? _jobCard;
  JobCardResponse? get jobCard => _jobCard;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isError = false;
  bool get isError => _isError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final String? jobCardId;

  _JobCardDetailScreenState(this.jobCardId) {
    _isLoading = true;
    getJobCardByIdAsync();
  }

  Future<void> getJobCardByIdAsync() async {
    _isLoading = true;
    _isError = false;
    _errorMessage = '';
    try {
      final jobCard = await JobCardService.getJobCardByIdAsync(jobCardId!);
      _jobCard = jobCard;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _isError = true;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}

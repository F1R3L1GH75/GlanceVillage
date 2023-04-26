import 'package:flutter/material.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:glancefrontend/services/api/jobcard_service.dart';
import 'package:intl/intl.dart';
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
                    Text(
                      'Error: ${provider.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2661FA),
                        ),
                        label: const Text('Go Back'))
                  ],
                ),
              ),
            );
          } else {
            final address = [
              jobCard!.address,
              jobCard.village,
              jobCard.district,
              jobCard.state,
              jobCard.pinCode,
            ];
            return Scaffold(
                appBar: AppBar(
                    backgroundColor: const Color(0xFF2661FA),
                    title: const Text('Job Card Details')),
                body: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                          'https://${ApiSettings.baseUrl}/Files/Images/$jobCardId/${jobCardId}_0310.jpeg'),
                      _ProfileDetailColumn(
                        title: 'JobCard Number',
                        value: jobCard.jobCardNumber ?? 'Not Available',
                      ),
                      _ProfileDetailColumn(
                        title: 'Name',
                        value: jobCard.name ?? 'Not Available',
                      ),
                      _ProfileDetailColumn(
                        title: 'Father/Husband Name',
                        value: jobCard.fatherOrHusbandName ?? 'Not Available',
                      ),
                      _ProfileDetailColumn(
                        title: 'Email',
                        value: jobCard.email ?? 'Not Available',
                      ),
                      _ProfileDetailColumn(
                        title: 'Phone Number',
                        value: jobCard.mobileNumber ?? 'Not Available',
                      ),
                      _ProfileDetailColumn(
                        title: 'Date of Birth',
                        value: DateFormat('dd/MM/yyyy')
                            .format(jobCard.dateOfBirth),
                      ),
                      _ProfileDetailColumn(
                        title: 'Ration Card Number',
                        value: jobCard.rationCardNumber ?? 'Not Available',
                      ),
                      _ProfileDetailColumn(
                        title: 'Gender',
                        value: jobCard.gender!,
                      ),
                      _ProfileDetailColumn(
                        title: 'Category',
                        value: jobCard.category ?? 'Not Available',
                      ),
                      _ProfileDetailColumn(
                        title: 'Address',
                        value: address.join(', '),
                      ),
                      _ProfileDetailColumn(
                        title: 'Verified on',
                        value: jobCard.verifiedOn ?? 'Not Verified',
                      ),
                    ],
                  ),
                )));
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

class _ProfileDetailColumn extends StatelessWidget {
  const _ProfileDetailColumn(
      {Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                    ),
                    const SizedBox(height: 10),
                    Text(value),
                  ],
                )),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Icon(
                    Icons.info_outline,
                    size: 17,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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

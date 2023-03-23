import 'package:flutter/material.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/services/api/jobcard_service.dart';

class JobCardDetailScreen extends StatefulWidget {
  const JobCardDetailScreen({super.key, required this.jobCardId});

  final String? jobCardId;

  @override
  State<JobCardDetailScreen> createState() => _JobCardDetailScreenState();
}

class _JobCardDetailScreenState extends State<JobCardDetailScreen> {
  late Future<JobCardResponse> _jobCard;

  @override
  void initState() {
    super.initState();
    _jobCard = JobCardService.getJobCardByIdAsync(widget.jobCardId!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JobCardResponse>(
      future: _jobCard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Job Card Detail: ${snapshot.data!.jobCardNumber}'),
              backgroundColor: const Color(0xFF2661FA),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      'Job Card Number: ${snapshot.data!.jobCardNumber}'),
                                  subtitle: Text(
                                      'Job Card Name: ${snapshot.data!.name}'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('${snapshot.error}')));
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Loading...'),
                backgroundColor: const Color(0xFF2661FA),
              ),
              body: SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator()),
                        Text('Loading Job Card Details...')
                      ])));
        }
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:intl/intl.dart';

class JobCardDetailedScreen extends StatelessWidget {
  const JobCardDetailedScreen({Key? key, required this.jobCard})
      : super(key: key);
  static String routeName = 'MyJobCardDetailedScreen';

  final JobCardResponse? jobCard;

  @override
  Widget build(BuildContext context) {
    final address = [
      jobCard!.address as String,
      jobCard!.village as String,
      jobCard!.district as String,
      jobCard!.state as String,
      jobCard!.pinCode as String
    ];
    return Scaffold(
      //app bar theme for tablet
      appBar: AppBar(
        backgroundColor: const Color(0xFF2661FA),
        title: const Text('Job Card Details'),
        actions: [
          InkWell(
            child: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                children: [
                  const Icon(Icons.report_gmailerrorred_outlined),
                  const SizedBox(width: 10),
                  Text(
                    'Report',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileDetailColumn(
                title: 'JobCard Number',
                value: jobCard!.jobCardNumber!,
              ),
              ProfileDetailColumn(
                title: 'Name',
                value: jobCard!.name!,
              ),
              ProfileDetailColumn(
                title: 'Father/Husband Name',
                value: jobCard!.fatherOrHusbandName!,
              ),
              ProfileDetailColumn(
                title: 'Email',
                value: jobCard!.email!,
              ),
              ProfileDetailColumn(
                title: 'Phone Number',
                value: jobCard!.mobileNumber!,
              ),
              ProfileDetailColumn(
                title: 'Date of Birth',
                value: DateFormat('dd/MM/yyyy').format(jobCard!.dateOfBirth),
              ),
              ProfileDetailColumn(
                title: 'Ration Card Number',
                value: jobCard!.rationCardNumber!,
              ),
              ProfileDetailColumn(
                title: 'Gender',
                value: jobCard!.gender!,
              ),
              ProfileDetailColumn(
                title: 'Category',
                value: jobCard!.category!,
              ),
              ProfileDetailColumn(
                title: 'Address',
                value: address.join(', '),
              ),
              ProfileDetailColumn(
                title: 'Verified on',
                value: jobCard?.verifiedOn ?? 'Not Verified',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetailColumn extends StatelessWidget {
  const ProfileDetailColumn(
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
                    //width: double.infinity,
                    // child: Divider(
                    //   thickness: 1.0,
                    // ),
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

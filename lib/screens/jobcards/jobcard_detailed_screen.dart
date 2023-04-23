import 'package:flutter/material.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/services/api/jobcard_service.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);
  static String routeName = 'MyJobCardDetailedScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar theme for tablet
      appBar: AppBar(
        title: Text('Job Card Details'),
        actions: [
          InkWell(
            child: Container(
              padding: EdgeInsets.only(right: 24 / 2),
              child: Row(
                children: [
                  Icon(Icons.report_gmailerrorred_outlined),
                  const SizedBox(height: 10),
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
        child: Column(
          children: [
            Container(
              width: 100,
              height: 19,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/student_profile.jpeg'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'test',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('Worker',
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(
                    title: 'JobCard Number', value: '2020-ASDF-2021'),
                ProfileDetailRow(title: 'JobCard id', value: '2020-2021'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(title: 'Aadhar Number', value: '98876656'),
                ProfileDetailRow(title: 'Email ', value: 'r@gmal.com'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(
                    title: 'Ration Card Number', value: '202320222020'),
                ProfileDetailRow(title: 'Date of Birth', value: '3 May 1998'),
              ],
            ),
            const SizedBox(height: 10),
            ProfileDetailColumn(
              title: 'Email',
              value: 'test@gmail.com',
            ),
            ProfileDetailColumn(
              title: 'Father Name',
              value: 'test dad ',
            ),
            ProfileDetailColumn(
              title: 'Mother Name',
              value: 'Test mom',
            ),
            ProfileDetailColumn(
              title: 'Phone Number',
              value: '+923066666666',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 9,
                    ),
              ),
              const SizedBox(height: 10),
              Text(value, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 10),
              SizedBox(
                width: 35,
                child: Divider(
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          Icon(
            Icons.lock_outline,
            size: 10,
          ),
        ],
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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 10),
              Text(value, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 10),
              SizedBox(
                width: 92,
                child: Divider(
                  thickness: 1.0,
                ),
              )
            ],
          ),
          Icon(
            Icons.lock_outline,
            size: 10,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:glancefrontend/components/app_drawer.dart';
import 'package:glancefrontend/models/dashboard_stat_response.dart';
import 'package:glancefrontend/services/api/dashboard_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Glance'),
          backgroundColor: const Color(0xFF2661FA),
        ),
        body: _DashboardStats());
  }
}

class _DashboardStats extends StatefulWidget {
  @override
  _DashboardStatsState createState() => _DashboardStatsState();
}

class _DashboardStatsState extends State<_DashboardStats> {

  late Future<DashboardStatResponse> _dashboardStats;

  @override
  void initState() {
    super.initState();
    _dashboardStats = DashboardService.getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 12, left: 28, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children : [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DASHBOARD INSIGHTS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Last updated on ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}', style: const TextStyle(fontSize: 12)),
                    ]
                  )
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: FutureBuilder<DashboardStatResponse>(
                future: _dashboardStats,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Card(
                            child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Villages',
                                          style: TextStyle(fontSize: 16)),
                                      Text(snapshot.data?.totalVillagesInUserAssignedPanchayats
                                          .toString() ?? '0',
                                          style: const TextStyle(
                                              fontSize: 20)),
                                    ],
                                  ),
                                ))),
                        Card(
                            child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Job Cards',
                                          style: TextStyle(fontSize: 16)),
                                      Text(snapshot.data
                                          ?.totalJobCardsInUserAssignedPanchayats
                                          .toString() ?? '0',
                                          style: const TextStyle(
                                              fontSize: 20)),
                                    ],
                                  )),
                                )),
                        Card(
                            child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                          'Total New Applications This Year',
                                          style: TextStyle(fontSize: 16)),
                                      Text(snapshot.data
                                          ?.totalNewApplicationsThisYearInUserAssignedPanchayats
                                          .toString() ?? '0',
                                          style: const TextStyle(
                                              fontSize: 20)),
                                    ],
                                  )),
                                )),
                        Card(
                            child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Ongoing Works Today',
                                          style: TextStyle(fontSize: 16)),
                                      Text(snapshot.data
                                          ?.totalOngoingWorksTodayInUserAssignedPanchayats
                                          .toString() ?? '0',
                                          style: const TextStyle(
                                              fontSize: 20)),
                                    ],
                                  )),
                                )),
                        Card(
                            child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Work Orders Today',
                                          style: TextStyle(fontSize: 16)),
                                      Text(snapshot.data
                                          ?.totalWorkOrdersTodayInUserAssignedPanchayats
                                          .toString() ?? '0',
                                          style: const TextStyle(
                                              fontSize: 20)),
                                    ],
                                  )),
                                )),
                        Card(
                            child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                          'Total Allocated Workers Today',
                                          style: TextStyle(fontSize: 16)),
                                      Text(snapshot.data
                                          ?.totalAllottedWorkersTodayInUserAssignedPanchayats
                                          .toString() ?? '0',
                                          style: const TextStyle(
                                              fontSize: 20)),
                                    ],
                                  )),
                                )),
                      ],
                    );
                  } else if(snapshot.hasError) {
                    return Column(children : [Text('Error: ${snapshot.error}')]);
                  }
                  return Column(children : const [CircularProgressIndicator()]);
                },
              ),
            )
          ]
        ),
      ),
    );
  }
}
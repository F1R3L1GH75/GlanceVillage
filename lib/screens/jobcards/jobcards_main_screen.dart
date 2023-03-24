import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glancefrontend/models/users/user_assigned_panchayats.dart';
import 'package:glancefrontend/screens/jobcards/dialogs/select_searchtype_dialog.dart';
import 'package:glancefrontend/screens/jobcards/jobcard_detail_screen.dart';
import 'package:glancefrontend/services/api/user_service.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class JobCardsScreen extends StatelessWidget {
  const JobCardsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Job Cards'),
        backgroundColor: const Color(0xFF2661FA),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search Job Cards')));
                    showDialog(
                        context: context,
                        builder: (_) => const SelectSearchTypeDialog());
                  },
                  child: const Icon(Icons.search))),
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Menu')));
                  },
                  child: const Icon(Icons.more_vert)))
        ],
      ),
      body: const LoadUserPanchayats(),
      floatingActionButton: const ScanQrCodeForJobCard(),
    );
  }
}

class LoadUserPanchayats extends StatefulWidget {
  const LoadUserPanchayats({super.key});

  @override
  State<LoadUserPanchayats> createState() => _LoadUserPanchayatsState();
}

class _LoadUserPanchayatsState extends State<LoadUserPanchayats> {
  late Future<UserAssignedPanchayats> userAssignedPanchayats;
  PanchayatResponse? _selectedPanchayat;
  @override
  void initState() {
    super.initState();
    userAssignedPanchayats = UserService.getUserAssignedPanchayats();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userAssignedPanchayats,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _selectedPanchayat ??= snapshot.data!.panchayats.first;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 15),
                    child: DropdownButton<PanchayatResponse>(
                        isExpanded: true,
                        value: _selectedPanchayat,
                        items: snapshot.data!.panchayats
                            .map<DropdownMenuItem<PanchayatResponse>>((val) {
                          return DropdownMenuItem<PanchayatResponse>(
                              value: val, child: Text(val.name));
                        }).toList(),
                        onChanged: (item) {
                          setState(() {
                            _selectedPanchayat = item!;
                          });
                        }),
                  )
                ]);
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class ScanQrCodeForJobCard extends StatefulWidget {
  const ScanQrCodeForJobCard({Key? key}) : super(key: key);

  @override
  State<ScanQrCodeForJobCard> createState() => _ScanQrCodeForJobCardState();
}

class _ScanQrCodeForJobCardState extends State<ScanQrCodeForJobCard> {
  String result = "";

  scanQR(BuildContext context) async {
    try {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        result = cameraScanResult.toString();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => JobCardDetailScreen(jobCardId: result)));
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get platform version. $e')));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => scanQR(context),
      backgroundColor: const Color(0xFF2661FA),
      child: const Icon(Icons.qr_code_scanner),
    );
  }
}

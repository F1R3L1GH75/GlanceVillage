import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glancefrontend/screens/jobcards/dialogs/select_searchtype_dialog.dart';
import 'package:glancefrontend/screens/jobcards/jobcard_detail_screen.dart';
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
                showDialog(context: context, builder: (_) => const SelectSearchTypeDialog());
              },
              child: const Icon(Icons.search)
            )
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu')));
              },
              child: const Icon(Icons.more_vert)
            )
          )
        ],
      ),
      body: const Center(
        child: Text('Job Cards Screen'),
      ),
      floatingActionButton: const ScanQrCodeForJobCard(),
    );
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
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobCardDetailScreen(jobCardId: result)));
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get platform version. $e')));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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

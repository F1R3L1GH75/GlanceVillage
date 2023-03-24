import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/models/users/user_assigned_panchayats.dart';
import 'package:glancefrontend/screens/jobcards/dialogs/select_searchtype_dialog.dart';
import 'package:glancefrontend/screens/jobcards/jobcard_detail_screen.dart';
import 'package:glancefrontend/services/api/jobcard_service.dart';
import 'package:glancefrontend/services/api/user_service.dart';
import 'package:provider/provider.dart';
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
      body: ChangeNotifierProvider<JobCardsScreenState>(
        create: (_) => JobCardsScreenState(),
        builder: (context, child) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
              child: DropdownButton<PanchayatResponse>(
                  isExpanded: true,
                  value: context.watch<JobCardsScreenState>().selectedPanchayat,
                  items: context
                      .read<JobCardsScreenState>()
                      .panchayats
                      .map<DropdownMenuItem<PanchayatResponse>>((val) {
                    return DropdownMenuItem<PanchayatResponse>(
                        value: val, child: Text(val.name));
                  }).toList(),
                  onChanged: (item) {
                    context
                        .read<JobCardsScreenState>()
                        .setSelectedPanchayat(item);
                  }),
            ),
            SingleChildScrollView(
                child: ListView.builder(
              itemCount: context.read<JobCardsScreenState>().jobCards.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(context
                        .read<JobCardsScreenState>()
                        .jobCards[index]
                        .name),
                    subtitle: Text(context
                        .read<JobCardsScreenState>()
                        .jobCards[index]
                        .jobCardNumber),
                  ),
                );
              },
            ))
          ]);
        },
      ), //const LoadUserPanchayats(),
      floatingActionButton: const ScanQrCodeForJobCard(),
    );
  }
}

class JobCardsScreenState with ChangeNotifier {
  List<PanchayatResponse> _panchayats = [];
  List<PanchayatResponse> get panchayats => _panchayats;

  PanchayatResponse? _selectedPanchayat;
  PanchayatResponse? get selectedPanchayat => _selectedPanchayat;

  List<JobCardResponse> _jobCards = [];
  List<JobCardResponse> get jobCards => _jobCards;

  int _pageNumber = 1;
  int get pageNumber => _pageNumber;
  void setPageNumber(int page) {
    _pageNumber = page;
    notifyListeners();
  }

  final int _pageSize = 10;
  int get pageSize => _pageSize;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  JobCardsScreenState() {
    loadUserPanchayats();
  }

  Future<void> loadUserPanchayats() async {
    try {
      final userAssignedPanchayats =
          await UserService.getUserAssignedPanchayats();
      _panchayats = userAssignedPanchayats.panchayats;
      _selectedPanchayat = _panchayats.first;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setSelectedPanchayat(PanchayatResponse? panchayat) {
    _selectedPanchayat = panchayat;
    loadJobCards();
    notifyListeners();
  }

  Future<void> loadJobCards() async {
    try {
      if (_selectedPanchayat == null) return;
      final jobCards = await JobCardService.getAll(
          _pageNumber, _pageSize, _searchQuery, _selectedPanchayat!);
      _jobCards = jobCards.data!;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
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
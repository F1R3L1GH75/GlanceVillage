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
import 'package:permission_handler/permission_handler.dart';

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
      body: ChangeNotifierProvider<_JobCardsScreenState>(
        create: (_) => _JobCardsScreenState(),
        builder: (context, child) {
          final provider =
              Provider.of<_JobCardsScreenState>(context, listen: true);
          return Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: DropdownButton<PanchayatResponse>(
                  isExpanded: true,
                  value: provider.selectedPanchayat,
                  items: provider.panchayats
                      .map<DropdownMenuItem<PanchayatResponse>>((val) {
                    return DropdownMenuItem<PanchayatResponse>(
                        value: val, child: Text(val.name));
                  }).toList(),
                  onChanged: (item) {
                    provider.setSelectedPanchayat(item);
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: provider.jobCards.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final jobCard = provider.jobCards[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => JobCardDetailScreen(
                                      jobCardId: jobCard.id)));
                        },
                        title: Text(jobCard.name!),
                        subtitle: Text(
                            '${jobCard.jobCardNumber}, Age ${(DateTime.now().difference(jobCard.dateOfBirth).inDays ~/ 365)}'),
                      ),
                    );
                  },
                ),
              ),
            )
          ]);
        },
      ),
      floatingActionButton: const ScanQrCodeForJobCard(),
    );
  }
}

class _JobCardsScreenState with ChangeNotifier {
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

  _JobCardsScreenState() {
    loadUserPanchayats();
  }

  Future<void> loadUserPanchayats() async {
    try {
      final userAssignedPanchayats =
          await UserService.getUserAssignedPanchayats();
      _panchayats = userAssignedPanchayats.panchayats;
      setSelectedPanchayat(panchayats.first);
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
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (result != PermissionStatus.granted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Camera permission is required')));
          }
        }
      }
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

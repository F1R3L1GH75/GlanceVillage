import 'package:flutter/material.dart';
import 'package:glancefrontend/models/users/user_assigned_panchayats.dart';
import 'package:glancefrontend/models/works/work_response.dart';
import 'package:glancefrontend/screens/works/work_detail_screen.dart';
import 'package:glancefrontend/services/api/user_service.dart';
import 'package:glancefrontend/services/api/work_service.dart';
import 'package:provider/provider.dart';

class WorksMainScreen extends StatelessWidget {
  const WorksMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Works'),
        backgroundColor: const Color(0xFF2661FA),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search Job Cards')));
                    // showDialog(
                    //     context: context,
                    //     builder: (_) => const SelectSearchTypeDialog());
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
      body: ChangeNotifierProvider<WorksScreenState>(
        create: (_) => WorksScreenState(),
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: DropdownButton<PanchayatResponse>(
                    isExpanded: true,
                    value: context.watch<WorksScreenState>().selectedPanchayat,
                    items: context
                        .read<WorksScreenState>()
                        .panchayats
                        .map<DropdownMenuItem<PanchayatResponse>>((val) {
                      return DropdownMenuItem<PanchayatResponse>(
                          value: val, child: Text(val.name));
                    }).toList(),
                    onChanged: (item) {
                      context
                          .read<WorksScreenState>()
                          .setSelectedPanchayat(item);
                    }),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: context.watch<WorksScreenState>().works.length,
                  itemBuilder: (context, index) {
                    final work = context.read<WorksScreenState>().works[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      WorkDetailScreen(workId: work.id)));
                        },
                        title: Text(work.name!),
                        subtitle: Text('${work.code!}, ${work.location!}'),
                      ),
                    );
                  },
                ),
              ))
            ],
          );
        },
      ),
    );
  }
}

class WorksScreenState with ChangeNotifier {
  List<PanchayatResponse> _panchayats = [];
  List<PanchayatResponse> get panchayats => _panchayats;

  PanchayatResponse? _selectedPanchayat;
  PanchayatResponse? get selectedPanchayat => _selectedPanchayat;

  List<WorkResponse> _works = [];
  List<WorkResponse> get works => _works;

  int _pageNumber = 1;
  int get pageNumber => _pageNumber;
  void setPageNumber(int page) {
    _pageNumber = page;
    loadWorks();
    notifyListeners();
  }

  final int _pageSize = 10;
  int get pageSize => _pageSize;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  void setSearchQuery(String query) {
    _searchQuery = query;
    loadWorks();
    notifyListeners();
  }

  WorksScreenState() {
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
    loadWorks();
    notifyListeners();
  }

  Future<void> loadWorks() async {
    try {
      if (_selectedPanchayat == null) return;
      final works = await WorkService.getAll(
          _pageNumber, _pageSize, _searchQuery, _selectedPanchayat!.id);
      _works = works.data!;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:glancefrontend/screens/home_screen.dart';
import 'package:glancefrontend/screens/login_screen.dart';
import 'package:glancefrontend/screens/settings_screen.dart';
import 'package:glancefrontend/services/claim_data_service.dart';
import 'package:glancefrontend/services/local_storage.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 50, 50)),
            accountName: FutureBuilder<String>(
                future: ClaimDataService.getUserName(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if(snapshot.hasData) {
                    return Text(snapshot.data!, style: const TextStyle(fontWeight: FontWeight.bold));
                  } else {
                    return const Text("FireLights", style: TextStyle(fontWeight: FontWeight.bold));
                  }
                }
            ),
            accountEmail: FutureBuilder<String>(
              future: ClaimDataService.getEmail(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if(snapshot.hasData) {
                  return Text(snapshot.data!, style: const TextStyle(fontWeight: FontWeight.bold));
                } else {
                  return const Text("fireLights@glance-village.com", style: TextStyle(fontWeight: FontWeight.bold));
                }
              },
            ),
            currentAccountPicture: const FlutterLogo(),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const HomeScreen()), (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings '),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout '),
            onTap: () {
              LocalStorage.deleteAll();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 50, 50, 50)),
              accountName: Text(
                "FireLights",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "firelights@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: FlutterLogo(),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.black),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: const [
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

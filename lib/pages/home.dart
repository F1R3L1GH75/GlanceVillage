import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:glancefrontend/components/navbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
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

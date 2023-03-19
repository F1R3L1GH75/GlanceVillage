import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search Job Cards')));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Job Card')));
        },
        backgroundColor: const Color(0xFF2661FA),
        child: const Icon(Icons.add),
      )
    );
  }
}
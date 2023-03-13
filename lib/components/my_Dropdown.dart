import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Select Role',
  'Admin',
  'Officer',
  'Supervisor',
  'User'
];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key, required this.roleController});
  final TextEditingController roleController;

  @override
  State<DropdownButtonExample> createState() =>
      _DropdownButtonExampleState(roleController: roleController);
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;
  final TextEditingController roleController;

  _DropdownButtonExampleState({required this.roleController});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      isExpanded: true,
      iconEnabledColor: Colors.deepPurple,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          roleController.text = dropdownValue;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

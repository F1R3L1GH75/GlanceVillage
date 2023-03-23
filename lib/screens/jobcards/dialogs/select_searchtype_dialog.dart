import 'package:flutter/material.dart';

class SelectSearchTypeDialog extends StatefulWidget {
  const SelectSearchTypeDialog({Key? key}) : super(key: key);

  @override
  State<SelectSearchTypeDialog> createState() => _SelectSearchTypeDialogState();
}

class _SelectSearchTypeDialogState extends State<SelectSearchTypeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        alignment: Alignment.center,
        child: dialogContent(context),
      );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              "Select Search Type",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, "Job Card Number");
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    backgroundColor: const Color(0xFF2661FA),
                  ),
                  child: const Text("Job Card Number"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, "Manual Search");
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: const Color(0xFF2661FA),
                  ),
                  child: const Text("Manual Search"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
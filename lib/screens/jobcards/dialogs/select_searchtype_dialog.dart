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
      padding: const EdgeInsets.all(16),
      height: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              "Search using",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, "Job Card Number");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2661FA),
                    ),
                    child: const Text("Job Card Number"),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, "Manual Search");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2661FA),
                    ),
                    child: const Text("Manual Search"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

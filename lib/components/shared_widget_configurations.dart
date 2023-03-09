import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration forTextFormField({required String hintText, required String labelText, required IconData prefixIcon}) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2),
      ),
      //hintText: hintText,
      labelText: labelText,
      prefixIcon: Icon(prefixIcon)
    );
  }
}
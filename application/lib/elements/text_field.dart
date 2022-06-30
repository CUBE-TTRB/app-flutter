import 'package:flutter/material.dart';

import '../values/colors.dart';

class SoftTextField extends StatelessWidget {
  const SoftTextField ({Key? key, required this.hintText, required this.controller, required this.obscureText}) : super(key: key);
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      autocorrect: false,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsDictionary.subtleLightGrey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsDictionary.subtleLightGrey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: ColorsDictionary.subtleLightGrey,
        hintStyle: TextStyle(color: ColorsDictionary.darkGrey),
        hintText: hintText,
      ),
    );
  }
}

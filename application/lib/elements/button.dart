import 'package:flutter/material.dart';

import '../values/colors.dart';

class SoftButton extends InkWell {
  const SoftButton({
    Key? key,
    required this.textColor,
    required this.text,
    required this.color,
    required this.onClick,
  }) : super(key: key);
  final String text;
  final Color color;
  final Color textColor;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onClick,
        child: Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: size.width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w500)
        ,),
    ));
  }
}

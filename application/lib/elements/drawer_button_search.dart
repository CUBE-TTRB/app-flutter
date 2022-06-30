import 'package:cube/elements/drawer_search.dart';
import 'package:cube/values/colors.dart';
import 'package:flutter/material.dart';

class ButtonDrawerSearch extends StatefulWidget {
  const ButtonDrawerSearch({Key? key, required this.onClick, required this.isClicked, required this.buttonInfos}) : super(key: key);

  final ButtonDrawerType buttonInfos;
  final Function(int buttonId) onClick;
  final bool isClicked;

  @override
  State<ButtonDrawerSearch> createState() => _ButtonDrawerSearchState();
}

class _ButtonDrawerSearchState extends State<ButtonDrawerSearch> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        widget.onClick(widget.buttonInfos.id);
        },
      child: Container(
        height: 40,
        width: size.width,
        decoration: BoxDecoration(
        color: widget.isClicked?ColorsDictionary.subtleCyan:Colors.white,
        border: Border.all(
          color: widget.isClicked?ColorsDictionary.subtleCyan:Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
          child: Text(widget.buttonInfos.textContent, style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}

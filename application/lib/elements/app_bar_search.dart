import 'package:cube/values/colors.dart';
import 'package:flutter/material.dart';

class AppBarSearch extends StatefulWidget {
  const AppBarSearch({Key? key, required this.onPressed, required this.isPressed}) : super(key: key);
  final Function() onPressed;
  final bool isPressed;
  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Icon(
                !widget.isPressed?Icons.menu_outlined:Icons.arrow_back_ios,
                color: ColorsDictionary.cyan,
                size: 30,
              ),
            ),
            onTap: widget.onPressed,
          ),
          Expanded(
            child: TextField(
              autocorrect: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Recherche",
                suffixIcon: const Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.search,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorsDictionary.subtleLightGrey),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorsDictionary.subtleLightGrey),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                fillColor: ColorsDictionary.subtleLightGrey,
                hintStyle: TextStyle(color: ColorsDictionary.darkGrey),
              ),
            ),
          ),
          InkWell(
              child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
            child: Icon(Icons.account_circle,
                color: ColorsDictionary.cyan, size: 30),
          )),
        ],
      ),
    );
  }
}

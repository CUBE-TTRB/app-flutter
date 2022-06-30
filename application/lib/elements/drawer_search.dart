import 'package:cube/elements/drawer_button_search.dart';
import 'package:flutter/material.dart';

import '../api/connexion_data.dart';

class DrawerSearch extends StatefulWidget {
  const DrawerSearch({Key? key, required this.sendRequest, required this.buttonIdSelected}) : super(key: key);
  final Function sendRequest;
  final int buttonIdSelected;
  @override
  State<DrawerSearch> createState() => _DrawerSearchState();
}


class _DrawerSearchState extends State<DrawerSearch> {
  List<ButtonDrawerType> buttons = <ButtonDrawerType>
  [
    ButtonDrawerType(0, "Articles", "articles"),
    ButtonDrawerType(1, "Vidéos", "video"),
    ButtonDrawerType(2, "Cours", "courses"),
    ButtonDrawerType(3, "Exercices", "exercices")
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    setSelectedButton(int idSelected) {
      widget.sendRequest(buttons.where((element) => element.id == idSelected).first);
      setState(() {});
    }

    return Container(
      color: Colors.white,
      width: size.width,
      child: Column(
        children: [
          ButtonDrawerSearch(
            buttonInfos: buttons[0],
            isClicked: widget.buttonIdSelected == buttons[0].id ? true : false,
            onClick: setSelectedButton,
          ),
          ButtonDrawerSearch(
            buttonInfos: buttons[1],
            isClicked: widget.buttonIdSelected == buttons[1].id ? true : false,
            onClick: setSelectedButton,
          ),
          ButtonDrawerSearch(
            buttonInfos: buttons[2],
            isClicked: widget.buttonIdSelected == buttons[2].id ? true : false,
            onClick: setSelectedButton,
          ),
          ButtonDrawerSearch(
            buttonInfos: buttons[3],
            isClicked: widget.buttonIdSelected == buttons[3].id ? true : false,
            onClick: setSelectedButton,
          )
        ],
      ),
    );
  }
}

class ButtonDrawerType {
  ButtonDrawerType(this.id, this.textContent, this.request);
  String textContent;
  int id;
  String request;
}


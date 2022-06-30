import 'dart:developer';

import 'package:cube/api/connexion_data.dart';
import 'package:cube/elements/app_bar_search.dart';
import 'package:cube/elements/drawer_search.dart';
import 'package:cube/elements/resource_element.dart';
import 'package:cube/resource_create.dart';
import 'package:cube/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/api_request.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.responseText}) : super(key: key);
  final String responseText;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ResourceElement> listResElement = [];
  int actualButtonSelected = -1;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    RequestDictionary.showRes().then((value) {
      log(value.length.toString() + " aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      if (listResElement.length != value.length) {
        listResElement = value;
        setState(() {});
      }
    });
    drawerSendResult(ButtonDrawerType buttonResult) {
      actualButtonSelected = buttonResult.id;
      _scaffoldKey.currentState?.closeDrawer();
      isOpen = false;
      setState(() {});
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Visibility(
          visible: ConnexionData.isConnected,
          child: InkWell(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: ColorsDictionary.cyan,
                border: Border.all(
                  color: ColorsDictionary.cyan,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(60.0),
              ),
              child: const Center(
                child: Text(
                  "Ajouter une ressource",
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateResourcePage()
                ),
              );
            },
          ),
        ) ,
        appBar: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: AppBarSearch(
              isPressed: isOpen,
              onPressed: () {
                if (isOpen) {
                  _scaffoldKey.currentState?.closeDrawer();
                  isOpen = false;
                } else {
                  _scaffoldKey.currentState?.openDrawer();
                  isOpen = true;
                }
                setState(() {});
              }),
          automaticallyImplyLeading: false,
        ),
        body: Scaffold(
          key: _scaffoldKey,
          drawer: DrawerSearch(
            buttonIdSelected: actualButtonSelected,
            sendRequest: drawerSendResult,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
             Container(
            alignment: Alignment.center,
              height: 60,
              child: Text("Liste des ressources", style: TextStyle(color: Colors.white,
              fontSize: 20, fontWeight: FontWeight.w500)),

              decoration: BoxDecoration(
                  color: ColorsDictionary.cyan,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.elliptical(200, 60),
                    bottomRight: Radius.elliptical(200, 60),
                  )),
                )     , Column(
                  children:  listResElement,
                ),
                Container(height: 150,)
              ],
            )

          ),
        ));
  }
}

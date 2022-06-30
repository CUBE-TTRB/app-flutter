import 'dart:ui';

import 'package:cube/api/connexion_data.dart';
import 'package:cube/elements/button.dart';
import 'package:cube/main.dart';
import 'package:cube/search_page.dart';
import 'package:cube/values/colors.dart';
import 'package:flutter/material.dart';

import 'api/api_request.dart';
import 'elements/text_field.dart';
import 'main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum loginStatePage { Connection, CreateAccount, ForgotPassword }

class loginPageContent {
  loginPageContent(this.topBarIconVisible, this.bottomBarIconVisible,
      this.middleBodyColor, this.state);

  late bool topBarIconVisible;

  late bool bottomBarIconVisible;

  late loginStatePage state;
  late Color middleBodyColor;
}

class _MyHomePageState extends State<MyHomePage> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerCreateEmail = TextEditingController();
  final controllerCreateName = TextEditingController();
  final controllerCreateFirstName = TextEditingController();
  final controllerCreatedateOfBirth = TextEditingController();
  final controllerCreatePassword = TextEditingController();

  Map<loginStatePage, loginPageContent> stateInfos = {
    loginStatePage.Connection:
        loginPageContent(false, true, Colors.white, loginStatePage.Connection),
    loginStatePage.CreateAccount: loginPageContent(
        true, false, ColorsDictionary.cyan, loginStatePage.CreateAccount),
    loginStatePage.ForgotPassword: loginPageContent(
        true, true, ColorsDictionary.darkCyan, loginStatePage.ForgotPassword),
  };
  loginPageContent actualState =
      loginPageContent(false, true, Colors.white, loginStatePage.Connection);

  Size? size;
  bool isCheked = false;

  void changeBottomContainerSize(loginStatePage statePage) {
    setState(() {
      actualState = stateInfos[statePage]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    double containairSize = size!.height / 4;
    bool connectBody = false;
    bool forgetPasswordBody = false;
    bool createAccountBody = false;
    if (actualState.state == loginStatePage.Connection) {
      connectBody = true;
    }
    if (actualState.state == loginStatePage.ForgotPassword) {
      forgetPasswordBody = true;
    }
    if (actualState.state == loginStatePage.CreateAccount) {
      createAccountBody = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Icon(Icons.highlight_remove),
        title: InkWell(

          child: Text(
            'Continuer hors-ligne',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SearchPage(responseText: "")),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 5,
      ),

      body: Center(
          child: Container(
        height: size!.height,
        color: actualState.middleBodyColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                if (actualState.topBarIconVisible) {
                  changeBottomContainerSize(loginStatePage.Connection);
                }
              },
              child: Container(
                  alignment: Alignment.center,
                  height: containairSize,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.elliptical(200, 60),
                        bottomRight: Radius.elliptical(200, 60),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Connectez-vous",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorsDictionary.darkCyan,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      Visibility(
                        child: Icon(
                          Icons.login,
                          color: ColorsDictionary.cyan,
                          size: 50,
                        ),
                        visible: actualState.topBarIconVisible,
                      )
                    ],
                  )),
            ),
            Expanded(
                // height: middleContainerSize,
                child: Visibility(
              visible: connectBody,
              replacement: Visibility(
                visible: createAccountBody,
                replacement: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Mot de passe oublié",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorsDictionary.green,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size!.width / 8, 0, size!.width / 8, 0),
                      child: SoftTextField(
                        hintText: "Adresse e-mail",
                        controller: controllerPassword,
                        obscureText: false,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size!.width / 10, 0, size!.width / 10, 0),
                      child: SoftButton(
                          text: "Valider",
                          color: ColorsDictionary.green,
                          textColor: ColorsDictionary.darkCyan,
                          onClick: () {}),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Créer un compte",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorsDictionary.darkCyan,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size!.width / 8, 0, size!.width / 8, 0),
                      child: SoftTextField(
                        hintText: "Nom",
                        controller: controllerCreateName,
                        obscureText: false,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size!.width / 8, 0, size!.width / 8, 0),
                      child: SoftTextField(
                        hintText: "Prénom",
                        controller: controllerCreateFirstName,
                        obscureText: false,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size!.width / 8, 0, size!.width / 8, 0),
                      child: SoftTextField(
                        hintText: "E-mail",
                        controller: controllerCreateEmail,
                        obscureText: false,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size!.width / 8, 0, size!.width / 8, 0),
                      child: SoftTextField(
                        hintText: "Date de naissance",
                        controller: controllerCreatedateOfBirth,
                        obscureText: false,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size!.width / 8, 0, size!.width / 8, 0),
                      child: SoftTextField(
                        hintText: "Mot de passe",
                        controller: controllerCreatePassword,
                        obscureText: false,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isCheked,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => ColorsDictionary.darkCyan),
                          onChanged: (val) {
                            setState(() {
                              isCheked = val!;
                            });
                          },
                        ),
                        Text("J'accepte les conditions d'utilisation")
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size!.width / 10, 0, size!.width / 10, 0),
                      child: SoftButton(
                          text: "Créer un compte",
                          color: ColorsDictionary.darkCyan,
                          textColor: Colors.white,
                          onClick: () {
                            if (isCheked) {
                              RequestDictionary.CreateUser(
                                      controllerCreateFirstName.text,
                                      controllerCreateEmail.text,
                                      controllerPassword.text,
                                      controllerCreateName.text,
                                      controllerCreatedateOfBirth.text
                                      )
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(value),

                                ));
                                changeBottomContainerSize(loginStatePage.Connection);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           SearchPage(responseText: value)),
                                // );
                              });
                            }
                          }),
                    ),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        size!.width / 8, 0, size!.width / 8, 0),
                    child: SoftTextField(
                      hintText: "Adresse Email",
                      controller: controllerEmail,
                      obscureText: false,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        size!.width / 8, 0, size!.width / 8, 0),
                    child: SoftTextField(
                      hintText: "Mot de passe",
                      controller: controllerPassword,
                      obscureText: true,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        size!.width / 4, 0, size!.width / 4, 0),
                    child: SoftButton(
                        text: "Valider",
                        color: ColorsDictionary.darkCyan,
                        textColor: Colors.white,
                        onClick: () {
                          RequestDictionary.connect(
                              controllerEmail.text,
                              controllerPassword.text)
                              .then((value) {
                            if(ConnexionData.userId!=-1){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchPage(responseText: value)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Nom de compte ou mot de passe incorrect !"),
                              ));
                            }


                          });
                        }),
                  ),
                  Text(
                    "Mot de passe oublié?",
                    style: TextStyle(color: ColorsDictionary.darkGrey),
                  ),
                  InkWell(
                    child: Text(
                      "Cliquez-ici?",
                      style: TextStyle(
                          color: ColorsDictionary.darkGrey,
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () => changeBottomContainerSize(
                        loginStatePage.ForgotPassword),
                  ),
                ],
              ),
            )),
            Visibility(
                visible: actualState.bottomBarIconVisible,
                child: InkWell(
                  onTap: () =>
                      changeBottomContainerSize(loginStatePage.CreateAccount),
                  child: Container(
                    alignment: Alignment.center,
                    height: containairSize,
                    decoration: BoxDecoration(
                        color: ColorsDictionary.cyan,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(200, 60),
                          topRight: Radius.elliptical(200, 60),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Créer un compte",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorsDictionary.darkCyan,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.login, color: Colors.white, size: 50),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

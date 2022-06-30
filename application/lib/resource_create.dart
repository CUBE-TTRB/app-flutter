import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cube/api/api_request.dart';
import 'package:cube/elements/button.dart';
import 'package:cube/elements/text_field.dart';
import 'package:cube/model/resources_model.dart';
import 'package:cube/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:image_picker/image_picker.dart';

import 'lib/payload_decoder.dart';

class CreateResourcePage extends StatefulWidget {
  const CreateResourcePage({Key? key}) : super(key: key);

  @override
  State<CreateResourcePage> createState() => _CreateResourcePageState();
}

class _CreateResourcePageState extends State<CreateResourcePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  bool isPrivate = false;
  String typeResource = "ACTIVITY";
  TextEditingController titleController = TextEditingController();
  QuillController quillController = QuillController(
      document: Document(),
      selection: const TextSelection(extentOffset: 0, baseOffset: 0));

  @override
  Widget build(BuildContext context) {
    getPictureFromPhoneCamera() async {
      photo = await _picker.pickImage(source: ImageSource.camera);
      setState(() {});
    }

    getPictureFromPhone() async {
      photo = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {});
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColorsDictionary.darkCyan,
                        border: Border.all(color: ColorsDictionary.darkCyan),
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: Text(
                        "Créer une ressource",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 25),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    child: SoftTextField(
                        hintText: "Titre :",
                        controller: titleController,
                        obscureText: false),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      "Ajouter une miniature",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: ColorsDictionary.cyan,
                          fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (() => getPictureFromPhone()),
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorsDictionary.cyan,
                            border: Border.all(
                              color: ColorsDictionary.cyan,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Text(
                            "Depuis la galerie",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 13),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (() => getPictureFromPhoneCamera()),
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorsDictionary.cyan,
                            border: Border.all(
                              color: ColorsDictionary.cyan,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Text(
                            "Depuis l'appareil photo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: size.height / 4,
                    margin: const EdgeInsets.all(20),
                    child: photo != null
                        ? Image.file(File(photo!.path))
                        : Image.network(
                            "https://static.thenounproject.com/png/220984-200.png"),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    width: size.width / 1.5,
                    decoration: BoxDecoration(
                        color: ColorsDictionary.cyan,
                        border: Border.all(color: ColorsDictionary.cyan),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            "Type de la ressource :",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          margin: EdgeInsets.all(10),
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: 150,
                          child: DropdownButton<String>(
                            value: typeResource,
                            icon: Icon(Icons.arrow_drop_down),
                            dropdownColor: ColorsDictionary.cyan,
                            items: const [
                              DropdownMenuItem<String>(
                                value: "ARTICLE",
                                child: Text("Article",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DropdownMenuItem<String>(
                                value: "EXERCISE",
                                child: Text("Exercice",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DropdownMenuItem<String>(
                                value: "ACTIVITY",
                                child: Text("Activité",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                            onChanged: (selectedItem) { typeResource = selectedItem!; setState((){});},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          QuillToolbar.basic(
                            controller: quillController,
                          ),
                          Container(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorsDictionary.cyan, width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: QuillEditor(
                                controller: quillController,
                                readOnly: false,
                                expands: false,
                                padding: const EdgeInsets.all(10),
                                scrollable: false,
                                focusNode: FocusNode(),
                                scrollController: ScrollController(),
                                autoFocus: true,
                                minHeight: 150,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text("Ressource privée ",style: TextStyle(color: ColorsDictionary.cyan, fontWeight: FontWeight.w300, fontSize: 16),),
                              Checkbox(
                                value: isPrivate, onChanged: (bool? value) {isPrivate = value!;},
                              ),
                            ],)

                          ),
                          Container(
                            margin: EdgeInsets.all(30),
                            child: SoftButton(
                              color: ColorsDictionary.cyan,
                              text: "Valider",
                              textColor: Colors.white,
                              onClick: () {

                                log(quillController.document.toDelta().toJson().toString());
                                ResourceModel resource = ResourceModel(
                                    -1,
                                    typeResource, 
                                    titleController.text,
                                    quillController.document.toDelta().toJson(),
                                    "null date",
                                    1,
                                    photo!=null?"data:image/png;base64,"+Decoder.ImageToBase64(photo!.path):"",
                                    quillController.document.toDelta().toString(),
                                    !isPrivate?"PRIVATE":"PUBLIC",
                                    "0","", []
                                );
                                RequestDictionary.createResource(resource).then((value){
                                  if(value){
                                    log("ok :)");
                                  }else{
                                    log("pas ok :'(");
                                  }
                                });

                              },
                            ),
                          ),
                          Container(height: 400,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:cube/api/api_request.dart';
import 'package:cube/api/connexion_data.dart';
import 'package:cube/elements/button.dart';
import 'package:cube/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'lib/payload_decoder.dart';
import 'model/comment_model.dart';
import 'model/resources_model.dart';

class RessourceDisplay extends StatefulWidget {
  const RessourceDisplay({Key? key, required this.resourceModel})
      : super(key: key);
  final ResourceModel resourceModel;

  @override
  State<RessourceDisplay> createState() => _RessourceDisplayState();
}

class _RessourceDisplayState extends State<RessourceDisplay> {
  Card createCommentContainer(CommentModel comment) {
    return Card(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        Text("Utilisateur : " + comment.userString, style: TextStyle(color: Colors.black, fontSize: 18)),
        Text("Date : " +comment.date, style: TextStyle(color: Colors.black, fontSize: 18)),
        Text("Commentaire :\n" +comment.text, style: TextStyle(color: Colors.black, fontSize: 18)),
      ]),
    );
  }

  bool isInitialized = false;
  List<Card> commentsDisplay = [];
  ScrollController scrollController =  ScrollController( );
  QuillController quillController = QuillController(
      document: Document(),
      selection: const TextSelection(extentOffset: 0, baseOffset: 0));

  @override
  Widget build(BuildContext context) {
    QuillController quillControllerComments = QuillController(
        document: Document(),
        selection: const TextSelection(extentOffset: 0, baseOffset: 0));

    Size size = MediaQuery.of(context).size;
    if (!isInitialized) {
      isInitialized = true;
      RequestDictionary.showResById(widget.resourceModel.id).then((value) {
        log("1 :) " +value.resourceModel.body.toString());
        log("4 :) " +value.resourceModel.body.toString());
        for (var element in value.resourceModel.comments) {
          commentsDisplay.add(createCommentContainer(element));
        }

        value.resourceModel.body;
        quillController = QuillController(
            document: Document.fromJson( value.resourceModel.body),
            selection: TextSelection.collapsed(offset: 0));
        setState(() {});
        });

        setState(() {});

    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Center(
          child: Container(
            width: size.width - size.width / 12,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: 5,
                      height: 30,
                      color: ColorsDictionary.cyan,
                    ),
                    Expanded(
                        child: Text(
                      widget.resourceModel.title,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: ColorsDictionary.darkCyan),
                    )),
                  ],
                ),
                Container(
                  height: 150,
                  child:  widget.resourceModel.thumbnail != null?Image.file(
                    Decoder.base64ToImage(widget.resourceModel.thumbnail!),
                    fit: BoxFit.fitHeight,
                  ):
                  Image.network(

                    "https://cdn3.iconfinder.com/data/icons/security-45/100/seurity-go-17-512.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Description :", style: TextStyle(color: ColorsDictionary.cyan, fontSize: 16, fontWeight: FontWeight.w400),),
                ),
                Container(
                  width: size.width,
                  child: Text(widget.resourceModel.description?? "Aucune description",
                      style: TextStyle(fontSize: 18)),
                ),
                Container(
                  child: QuillEditor.basic(
                    controller: quillController,
                    readOnly: true,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Commentaires :", style: TextStyle(color: ColorsDictionary.cyan, fontSize: 16, fontWeight: FontWeight.w400),),
                ),

                Text(commentsDisplay.length>0?"":"Il n'y a pas encore de commentaire.."),
                Container(
                  width: size.width,
                  child: Column(
                    children: commentsDisplay,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Ecrire une commentaire :", style: TextStyle(color: ColorsDictionary.cyan, fontSize: 16, fontWeight: FontWeight.w400),),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsDictionary.darkGrey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: QuillEditor(
                    controller: quillControllerComments,
                    readOnly: false, scrollable: true, focusNode: FocusNode(),
                    autoFocus: false, padding: EdgeInsets.zero,
                    scrollController: scrollController, expands: false,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: size.width / 2,
                  child: SoftButton(
                      textColor: ColorsDictionary.subtleCyan,
                      text: "Envoyer",
                      color: ConnexionData.userId==-1 ? ColorsDictionary.subtleLightGrey: ColorsDictionary.cyan,
                      onClick: () {
                        if(ConnexionData.userId != -1){
                          RequestDictionary.postComment(widget.resourceModel.id, quillControllerComments.document.toPlainText());
                        }
                      }),
                ),
                Container(
                  height: 500,
                )
              ],
            ),
          ),
        )));
  }
}

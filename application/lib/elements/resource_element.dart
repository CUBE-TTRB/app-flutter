import 'dart:developer';

import 'package:cube/model/resources_model.dart';
import 'package:cube/values/colors.dart';
import 'package:flutter/material.dart';

import '../lib/payload_decoder.dart';
import '../resource_display.dart';

class ResourceElement extends StatefulWidget {
  const ResourceElement({Key? key, required this.resourceModel, }) : super(key: key);
  final ResourceModel resourceModel;
  @override
  State<ResourceElement> createState() => _ResourceElementState();
}

class _ResourceElementState extends State<ResourceElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 5,
                  height: 30,
                  color: ColorsDictionary.cyan,
                ),
                Expanded(child: Text(widget.resourceModel.title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: ColorsDictionary.darkCyan),)),
                const Icon(Icons.flag_outlined)
              ],
            ),
            InkWell(
              child: Container(
                height: 150,
                child: widget.resourceModel.thumbnail!=null? Image.file(
                  Decoder.base64ToImage(widget.resourceModel.thumbnail!),
                ):Container(),
              ),
              onTap: (){
                log(widget.resourceModel.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RessourceDisplay(resourceModel: widget.resourceModel,)),
                );
              },
            )
            ,
            Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              height: 50,
              child:  Text(widget.resourceModel.description??"Aucune description"),
            ),

            Row(
              children: [
                Icon(Icons.question_mark, color: ColorsDictionary.cyan,),
                Spacer(),
                Container(
                  margin: EdgeInsets.all(10),
                  child:  Column(children: [
                    Icon(Icons.favorite_border, color: ColorsDictionary.darkGrey,),
                    Text("6")
                  ],),
                )
               ,
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(children: [
                    Icon(Icons.comment_bank_outlined, color: ColorsDictionary.darkGrey,),
                    Text(widget.resourceModel.commentCount.toString())
                  ],),
                )
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

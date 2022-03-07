import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scribble/View/Main/firstPage.dart';
import 'package:scribble/View/Main/mainScreen.dart';

// ignore: must_be_immutable
class InformationDialog extends StatelessWidget {
  final String title, content;

  const InformationDialog({this.title, this.content});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.4),
                blurRadius: 8,
                spreadRadius: 5)
          ],
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 26, color: Colors.red, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20)),
                onPressed: () {
                  Get.offAll(MainScreen());
                },
                child: Text(
                  "Go back",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

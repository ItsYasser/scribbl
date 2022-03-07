// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scribble/Util/myFunctions.dart';
import 'package:scribble/View/PaintScreen.dart';

import '../../Controllers/AuthController.dart';
import '../../Controllers/RoomController.dart';
import '../../constants.dart';
import '../../widgets/button.dart';
import '../../widgets/nextButton.dart';
import '../loadingScreen.dart';
import 'components/avatarSelector.dart';
import 'components/stepContainer.dart';

class SecondPage extends StatelessWidget {
  final PageController controller;
  SecondPage({
    Key key,
    this.controller,
  }) : super(key: key);
  final AuthController auth = Get.find<AuthController>();
  final RoomController room = Get.put(RoomController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          StepContainer(number: 2),
          AvatarSelecter(),
          BorderedText(
            strokeColor: Colors.black,
            strokeWidth: 2,
            child: Text(
              auth.user.name,
              style: TextStyle(color: kLightOrange, fontSize: 40),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Button(
            onTap: () {},
            child: TextFormField(
                style: TextStyle(fontSize: kTextfontSize),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  room.code = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "ROOM CODE",
                )),
          ),
          Button(
            onTap: () {},
            child: TextFormField(
                onTap: () {
                  room.createRoom(auth.user);
                },
                style: TextStyle(fontSize: kTextfontSize),
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "CREATE ROOM",
                )),
          ),
          SizedBox(
            height: 30,
          ),
          GetBuilder<RoomController>(
              // init: RoomController(),
              builder: (value) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Button(
                    child: Icon(
                      Icons.remove,
                      size: 50,
                    ),
                    height: 70,
                    onTap: value.decrease,
                  ),
                ),
                Button(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rounds",
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                        value.totalRounds.toString(),
                        style: TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                  height: 100,
                  width: size.width * 0.4,
                  onTap: () {},
                ),
                Expanded(
                  child: GestureDetector(
                    child: Button(
                      child: Icon(
                        Icons.add,
                        size: 50,
                      ),
                      height: 70,
                      onTap: value.increase,
                    ),
                  ),
                ),
              ],
            );
          }),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NextButton.icon(
                height: 50,
                width: 110,
                onTap: () {
                  controller.previousPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                },
                reverse: true,
              ),
              NextButton.icon(
                  height: 70,
                  width: 130,
                  onTap: () {
                    controller.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                  }),
            ],
          )
          // Button(
          //   child: Icon(
          //     Icons.remove,
          //   ),
          //   width: 100,
          //   height: 50,
          // ),
        ],
      ),
    );
  }
}

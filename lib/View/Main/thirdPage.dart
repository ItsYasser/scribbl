// ignore_for_file: prefer_const_constructors

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:scribble/Controllers/AuthController.dart';
import 'package:scribble/Controllers/RoomController.dart';
import 'package:scribble/View/PaintScreen.dart';
import 'package:scribble/View/loadingScreen.dart';
import 'package:scribble/View/paintingFrame.dart';
import 'package:scribble/widgets/logoText.dart';

import '../../constants.dart';
import '../../widgets/button.dart';
import '../../widgets/nextButton.dart';
import 'components/avatarSelector.dart';
import 'components/stepContainer.dart';

class ThirdPage extends StatelessWidget {
  RoomController roomController = Get.find<RoomController>();
  AuthController auth = Get.find<AuthController>();
  final PageController controller;
  ThirdPage({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StepContainer(number: 3),
        const SizedBox(
          height: 40,
        ),
        LogoText(),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SvgPicture.asset(
            "assets/images/${auth.user.avatar}.svg",
            height: 140,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        BorderedText(
          strokeColor: Colors.black,
          strokeWidth: 2,
          child: Text(
            auth.user.name,
            style: TextStyle(color: kLightOrange, fontSize: 40),
          ),
        ),
        Spacer(),

        NextButton(
          height: 70,
          width: 200,
          onTap: () {
            roomController.joinARoom();
          },
          title: 'JOIN',
        ),

        Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: NextButton.icon(
              height: 40,
              width: 70,
              onTap: () {
                controller.previousPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeIn);
              },
              reverse: true,
            ),
          ),
        ),
        // Spacer(),

        // Button(
        //   child: Icon(
        //     Icons.remove,
        //   ),
        //   width: 100,
        //   height: 50,
        // ),
      ],
    );
  }
}

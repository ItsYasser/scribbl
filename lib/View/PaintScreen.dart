// ignore_for_file: prefer_const_constructors, unused_local_variable, sized_box_for_whitespace

import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:scribble/Models/roomModel.dart';
import 'package:scribble/Models/userModel.dart';
import 'package:scribble/Util/firebase_user.dart';

import 'package:scribble/View/Main/components/timer.dart';
import 'package:scribble/View/paintingFrame.dart';
import 'package:scribble/constants.dart';

import '../Controllers/RoomController.dart';

class PaintScreen extends StatelessWidget {
  final RoomController roomController = Get.find<RoomController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return StreamBuilder<DocumentSnapshot>(
        stream: roomController.roomStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final doc = snapshot.data;

          roomController.theRoom = RoomModel.fromJson(doc.data());
          roomController.players.clear();
          for (var e in roomController.theRoom.players) {
            roomController.players.add(
              UserModel(e['id'], e['name'], e['avatar'], e['points']),
            );
          }
          if (roomController.theRoom.currentRound >
              roomController.theRoom.totalRounds) {
            Future.delayed(Duration.zero, () => roomController.gameOver());
          } else {
            if (roomController.theRoom.currentPainter ==
                    FireStoreUser.getUser().uid &&
                roomController.theRoom.theAnswer == "" &&
                roomController.theRoom.didStart) {
              Future.delayed(Duration.zero, () => roomController.play());
            } else {
              if (!roomController.theRoom.didStart &&
                  roomController.theRoom.players.length > 1) {
                if (FireStoreUser.getUser().uid ==
                    roomController.theRoom.roomOwner) {
                  roomController.startGame();
                }
              }
            }
            // if (roomController.theRoom.currentPainter ==
            //         FireStoreUser.getUser().uid &&
            //     roomController.theRoom.theAnswer == "" &&
            //     roomController.theRoom.didStart) {
            //   Future.delayed(Duration.zero, () => roomController.play());
            // }
          }
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: SizedBox(
                height: screenHeight - keyboardHeight,
                width: size.width,
                child: CustomScrollView(
                  physics: ClampingScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/Frame.png"),
                              fit: BoxFit.cover),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: size.height * 0.05,
                              child: Row(children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 2.5)),
                                  child: Text(
                                    roomController.theRoom.players.length == 1
                                        ? "ROUND 0"
                                        : "ROUND " +
                                            roomController.theRoom.currentRound
                                                .toString() +
                                            "/" +
                                            roomController.theRoom.totalRounds
                                                .toString(),
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Icon(Icons.home)),
                                Spacer(),
                                TimerWidget(),
                              ]),
                            ),
                            Expanded(
                              child: roomController.theRoom.players.length == 1
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: BorderedText(
                                        strokeColor: Colors.white,
                                        strokeWidth: 3,
                                        child: Text(
                                          "Don't Worry ! The Room is created.\nWe are just waiting for others to join\nSince you cant really play alone can ya ? 😂",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: kOrange,
                                              height: 1.2),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : PaintingFrame(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

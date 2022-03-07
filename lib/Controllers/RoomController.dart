// ignore_for_file: unnecessary_const, unnecessary_new

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scribble/Controllers/AuthController.dart';
import 'package:scribble/Models/roomModel.dart';
import 'package:scribble/Models/userModel.dart';
import 'package:scribble/Util/firebase_user.dart';
import 'package:scribble/Util/myFunctions.dart';
import 'package:scribble/View/PaintScreen.dart';
import 'package:scribble/View/loadingScreen.dart';
import 'package:scribble/widgets/dialog.dart';

import '../constants.dart';

class RoomController extends GetxController {
  int totalRounds = 1;
  final CollectionReference roomsCollection =
      FirebaseFirestore.instance.collection('Rooms');
  var subscription = FirebaseDatabase.instance;
  String code = "gh";
  List<String> myList = [
    'Box',
    'triangle',
    'mail',
    'infinity',
    'arrow',
    'Tree',
  ];
  AuthController authController = Get.find<AuthController>();
  final CollectionReference drawCollection =
      FirebaseFirestore.instance.collection('Boards');
  String msg;
  RoomModel theRoom;
  List<UserModel> players = [];

  int start = -1;
  void increase() {
    totalRounds++;
    update();
  }

  void delete() async {
    await FirebaseFirestore.instance.collection('Boards').doc("as").delete();
  }

  void joinARoom() async {
    await roomsCollection.doc(code).update({
      'players': FieldValue.arrayUnion([
        UserModel(FireStoreUser.getUser().uid, authController.user.name,
                authController.user.avatar, 0)
            .toJson()
      ])
    });
    Get.to(() => PaintScreen())?.then((value) => disconnectPlayerFromRoom());
  }

  void startPlaying() {
    // choose a painter
    // choose a word
  }
  void startTimer(Timestamp startAt, int seconds) async {
    if (startAt != null) {
      var vale = (startAt.seconds + seconds) - Timestamp.now().seconds;
      start = vale;

      const oneSec = const Duration(seconds: 1);
      new Timer.periodic(
        oneSec,
        (Timer timer) {
          if (start <= 0) {
          } else {
            start--;
            update(['timer']);
          }
        },
      );
    }
  }

  @override
  void onInit() {}

  void decrease() {
    if (totalRounds == 1) return;
    totalRounds--;
    update();
  }

  Stream<DocumentSnapshot<Object>> roomStream() {
    return roomsCollection.doc(code).snapshots();
  }

  void createRoom(UserModel player) async {
    RoomModel newRoom = RoomModel(code, 1, [player.toJson()], totalRounds,
        FireStoreUser.getUser().uid, '');
    var document = await roomsCollection.doc(code).get();
    if (document.exists) {
      snackBar(
          title: "Erreur Creating Room",
          message: "Rooms already exists with that code, write another one");
    } else {
      Get.to(() => LoadingPage());
      await roomsCollection.doc(code).set(newRoom.toJson());
      await drawCollection.doc(code).set({
        'details': '',
        'roomName': code,
      });
      theRoom = newRoom;
      Get.off(() => PaintScreen())?.then((value) => disconnectPlayerFromRoom());
    }
  }

  void disconnectPlayerFromRoom() async {
    await roomsCollection.doc(code).update({
      'players': FieldValue.arrayRemove([authController.user.toJson()])
    });
  }

  Stream<QuerySnapshot<Object>> chatStream() {
    print(code);
    return FirebaseFirestore.instance
        .collection('Chat')
        .doc(code)
        .collection("Messages")
        .snapshots();
  }

  void sendMessage() async {
    String docId = FirebaseFirestore.instance.collection("Chat").doc().id;
    AuthController auth = Get.find<AuthController>();
    await FirebaseFirestore.instance
        .collection('Chat')
        .doc(code)
        .collection("Messages")
        .add({
      'id': docId,
      'msg': msg,
      'senderID': FireStoreUser.getUser()?.uid,
      'senderName': auth.user.name
    });

    if (msg.toLowerCase() == theRoom.theAnswer.toLowerCase()) {
      // add 100 points to the player
      addPoints(FireStoreUser.getUser()?.uid);
      // decrease the rounds
      startGame();
      clearDrawing();
      await roomsCollection.doc(code).update({
        'currentRound': FieldValue.increment(1),
        'theAnswer': "",
        'startAt': "",
        'didStart': true,
      });
    }
  }

  void addPoints(String playerId) async {
    for (var i in players) {
      if (i.id == playerId) {
        i.points += 100;
      }
    }

    // if (theRoom.currentRound == 0) {
    //   Get.dialog(InformationDialog(
    //       title: "Game Over",
    //       content: "The game is over and the winner is : "));
    // }
    theRoom.players = getListMap(players);

    await roomsCollection.doc(code).update({'players': getListMap(players)});
  }

  void startGame() async {
    // circularDialog();
    //change to game started
    theRoom.didStart = true;
    //pick a painter
    Random random = new Random();
    int randomNumber = random.nextInt(theRoom.players.length);
    theRoom.currentPainter = theRoom.players.elementAt(randomNumber)['id'];
    roomsCollection.doc(code).update(theRoom.toJson());

    //display screen of words to the painter
  }

  void play() async {
    print("player");
    await Get.dialog(Di(), barrierDismissible: false).then((value) {
      if (value == null) {
        theRoom.theAnswer = myList[0];
      } else {
        theRoom.theAnswer = value;
      }
    });
    Random random = new Random();
    int randomNumber = random.nextInt(theRoom.players.length);
    theRoom.currentPainter = theRoom.players.elementAt(randomNumber)['id'];
    await roomsCollection.doc(code).update({
      'theAnswer': theRoom.theAnswer,
      'startAt': FieldValue.serverTimestamp()
    });
  }

  gameOver() {
    UserModel player;
    int max = 0;
    for (UserModel pl in players) {
      if (pl.points > max) {
        max = pl.points;
        player = pl;
      }
    }
    Get.dialog(InformationDialog(
        title: "Game Over",
        content: "The game is over and the winner is : ${player.name}"));
  }

  void clearDrawing() async {
    print('clearing');
    await drawCollection.doc(code).update({'details': []});
  }
}

class Di extends StatelessWidget {
  Di({Key key}) : super(key: key);

  RoomController roomController = Get.find<RoomController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 250,
            decoration: BoxDecoration(
                color: kGreyColor,
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.black.withOpacity(.4),
                //       blurRadius: 8,
                //       spreadRadius: 5)
                // ],
                border: Border.all(width: 3)),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(children: [
              const Text(
                "Choose A Word",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                    children: List.generate(
                  3,
                  (index) => GestureDetector(
                    onTap: () {
                      Get.back(result: roomController.myList[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      padding: const EdgeInsets.all(7),
                      width: double.infinity,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Text(
                        roomController.myList[index],
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            ])));
  }
}

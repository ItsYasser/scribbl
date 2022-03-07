// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:scribble/Controllers/RoomController.dart';
import 'package:scribble/Util/firebase_user.dart';
import 'package:scribble/Util/myFunctions.dart';
import 'package:scribble/View/PaintScreen.dart';
import 'package:scribble/View/example.dart';

import '../Models/touch_points.dart';
import '../constants.dart';
import '../widgets/custom_paint.dart';
import 'Main/components/playersTile.dart';

// class PaintingFrame extends StatefulWidget {
//   const PaintingFrame({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<PaintingFrame> createState() => _PaintingFrameState();
// }

// class _PaintingFrameState extends State<PaintingFrame> {
//   bool _finished = false;
//   PainterController _controller = _newController();
//   RoomController roomController = Get.find<RoomController>();
//   @override
//   void initState() {
//     super.initState();
//     // roomController.play();
//   }

//   static PainterController _newController() {
//     PainterController controller = new PainterController();
//     controller.thickness = 5.0;
//     controller.backgroundColor = Colors.transparent;

//     return controller;
//   }

//   @override
//   Widget build(BuildContext context) {
// return Column(
//   children: [
//     Expanded(
//       child: Stack(
//         children: [
//           // here where u can paint
//           Painter(_controller),
//           PlayersTile(
//             players: roomController.players,
//             selectedPlayerId: roomController.theRoom.currentPainter,
//           ),
//         ],
//       ),
//     ),
//     Container(
//       height: 80,
//       decoration: BoxDecoration(
//         color: kGreyColor,
//         border: Border.all(width: 3),
//       ),
//       child:
//           Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//         GestureDetector(
//             onTap: () {
//               _controller.clear();
//             },
//             child: Icon(Icons.delete)),
//         GestureDetector(
//           onTap: () {
//             _controller.undo();
//           },
//           child: Icon(
//             Icons.arrow_back,
//           ),
//         ),
//         Icon(
//           Icons.edit,
//           size: 40,
//         ),
//         new ColorPickerButton(
//           _controller,
//         ),
//         // Icon(Icons.color_lens_outlined),
//         Icon(Icons.add),
//       ]),
//     )
//   ],
// );
//   }
// }
class PaintingFrame extends StatefulWidget {
  @override
  _PaintingFrameState createState() => _PaintingFrameState();
}

class _PaintingFrameState extends State<PaintingFrame> {
  RoomController roomController = Get.find<RoomController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // here where u can paint
              // Painter(_controller),
              PaintArea(),
              PlayersTile(
                players: roomController.players,
                selectedPlayerId: roomController.theRoom.currentPainter,
              ),
            ],
          ),
        ),
        Container(
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kGreyColor,
              border: Border.all(width: 3),
            ),
            child: roomController.theRoom.currentPainter ==
                    FireStoreUser.getUser().uid
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        GestureDetector(
                            onTap: () {
                              // _controller.clear();
                              roomController.clearDrawing();
                            },
                            child: Icon(Icons.delete)),
                        GestureDetector(
                          onTap: () {
                            // _controller.undo();
                          },
                          child: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          size: 40,
                        ),
                        // new ColorPickerButton(
                        //   // _controller,
                        // ),
                        Icon(Icons.color_lens_outlined),
                        Icon(Icons.add),
                      ])
                : Text(
                    "Guess what's he drawing !",
                    style: TextStyle(fontSize: 23),
                  ))
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class PaintArea extends StatefulWidget {
  @override
  State<PaintArea> createState() => _PaintAreaState();
}

class _PaintAreaState extends State<PaintArea> {
  RoomController roomController = Get.find<RoomController>();

  final CollectionReference drawCollection =
      FirebaseFirestore.instance.collection('Boards');

  @override
  void initState() {
    connect();
  }

  List<TouchPoints> currenTpoints = [];
  List<List<TouchPoints>> allPoints = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;
  void connect() async {
    drawCollection.doc(roomController.code).snapshots().listen((event) {
      if (event.get('details') != null && event.get('details') != "") {
        setState(() {
          currenTpoints.clear();
          for (var i in event.get('details')) {
            // print(double.parse((i['point']['dx'])));

            currenTpoints.add(TouchPoints(
                points: Offset(
                  (double.parse((i['point']['dx']))),
                  (double.parse((i['point']['dy']))),
                ),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        currenTpoints.add(TouchPoints(
            points: Offset((details.localPosition.dx).toDouble(),
                (details.localPosition.dy).toDouble()),
            paint: Paint()
              ..strokeCap = strokeType
              ..isAntiAlias = true
              ..color = selectedColor.withOpacity(opacity)
              ..strokeWidth = strokeWidth));
        allPoints.add(currenTpoints);
        setState(() {});
      },
      onPanStart: (details) {
        currenTpoints.add(TouchPoints(
            points: Offset((details.localPosition.dx).toDouble(),
                (details.localPosition.dy).toDouble()),
            paint: Paint()
              ..strokeCap = strokeType
              ..isAntiAlias = true
              ..color = selectedColor.withOpacity(opacity)
              ..strokeWidth = strokeWidth));
        setState(() {});
      },
      onPanEnd: (details) {
        drawCollection.doc(roomController.code).update({
          'details': getListMap(currenTpoints),
          'roomName': roomController.code,
        });
        setState(() {});
        // print("done, PUSH");
      },
      child: SizedBox.expand(
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size.infinite,
            painter: MyCustomPainter(pointsList: currenTpoints),
          ),
        ),
      ),
    );
  }
}

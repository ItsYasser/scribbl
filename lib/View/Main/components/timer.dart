// ignore_for_file: prefer_const_constructors, unnecessary_const, unnecessary_new

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/RoomController.dart';

class TimerWidget extends StatelessWidget {
  final RoomController roomController = Get.find<RoomController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.2,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(width: 2.5)),
      child: StreamBuilder<DocumentSnapshot>(
          stream: roomController.roomStream(),
          builder: (context, snapshot) {
            final doc = snapshot.data;
            if (!snapshot.hasData || doc.get('startAt') == null) {
              return Text(
                '...',
                style: TextStyle(fontSize: 24),
              );
            }

            if (doc.get('startAt') == "") {
              return Text(
                '...',
                style: TextStyle(fontSize: 24),
              );
            } else {
              Future.delayed(Duration(seconds: 1));
              Timestamp startAt = doc.get('startAt');
              int seconds = 80;
              return Counter(
                start: (startAt.seconds + seconds) - Timestamp.now().seconds,
              );
            }
          }),
    );
  }
}

class Counter extends StatefulWidget {
  int start;
  Counter({
    Key key,
    this.start,
  }) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  Timer _timer;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.start <= 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            widget.start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Text(
      widget.start < 0 ? "..." : "${widget.start}",
      style: TextStyle(fontSize: 24),
    );
  }
}

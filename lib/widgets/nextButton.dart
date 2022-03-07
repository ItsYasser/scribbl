// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../constants.dart';

class NextButton extends StatelessWidget {
  Widget child;
  Color backGround = kOrange;
  bool reverse = false;
  final double height, width;
  final Function() onTap;
  NextButton(
      {String title,
      this.onTap,
      this.height = 70,
      this.width = double.infinity}) {
    child = Text(
      title,
      style: const TextStyle(
        fontSize: 40,
      ),
    );
  }
  NextButton.icon(
      {this.reverse = false,
      this.onTap,
      this.height = 70,
      this.width = double.infinity}) {
    child = const Icon(
      Icons.arrow_right_alt_sharp,
      size: 40,
    );
    if (reverse) {
      backGround = Colors.transparent;
      child = const RotatedBox(
        quarterTurns: 2,
        child: Icon(
          Icons.arrow_right_alt_sharp,
          size: 40,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: backGround,
          border: Border.all(
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: reverse == false ? Colors.black : Colors.transparent,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

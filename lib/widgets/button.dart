import 'package:flutter/material.dart';

import '../constants.dart';

class Button extends StatelessWidget {
  final Widget child;
  final double width, height;
  final Function() onTap;
  const Button(
      {this.child, this.width = double.infinity, this.height = 70, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: kOrange,
            border: Border.all(
              width: 3,
            )),
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: kLightOrange,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../constants.dart';

class StepContainer extends StatelessWidget {
  final int number;

  const StepContainer({Key key, this.number}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(3, (index) => item(index <= number - 1)));
  }

  Expanded item(bool colorize) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 13),
        height: 10,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5),
          color: colorize ? kOrange : kLightOrange,
        ),
      ),
    );
  }
}

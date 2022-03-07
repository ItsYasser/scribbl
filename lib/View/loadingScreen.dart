import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/logoText.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kHorizontalPadding, vertical: kVerticalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoText(),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: LinearProgressIndicator(
                      backgroundColor: kLightOrange,
                      color: kOrange,
                      minHeight: 10,
                      // value: 0.5,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}

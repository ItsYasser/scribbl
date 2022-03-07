import 'package:flutter/material.dart';
import 'package:scribble/View/Main/firstPage.dart';
import 'package:scribble/View/Main/secondPage.dart';
import 'package:scribble/View/Main/thirdPage.dart';

import '../../constants.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key key}) : super(key: key);
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    PageController controller = PageController(initialPage: 0);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kVerticalPadding, horizontal: kHorizontalPadding),
            child: Column(
              children: [
                Container(
                  height: size.height - 60,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: [
                      FirstPage(
                        pageController: controller,
                      ),
                      SecondPage(
                        controller: controller,
                      ),
                      ThirdPage(
                        controller: controller,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

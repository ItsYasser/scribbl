// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scribble/Controllers/AuthController.dart';

import '../../constants.dart';
import '../../widgets/button.dart';
import '../../widgets/logoText.dart';
import 'components/stepContainer.dart';

class FirstPage extends StatelessWidget {
  final PageController pageController;
  FirstPage({
    this.pageController,
  });
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController auth = Get.find<AuthController>();
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    textController.text = auth.user.name;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kVerticalPadding),
      child: Column(
        children: [
          StepContainer(number: 1),
          SizedBox(
            height: 100,
          ),
          LogoText(),
          SizedBox(
            height: 70,
          ),
          Form(
            key: _formKey,
            child: Button(
              onTap: () {},
              child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required.';
                    }
                    return null;
                  },
                  controller: textController,
                  onSaved: (value) {
                    auth.user.name = value;
                  },
                  style: TextStyle(fontSize: kTextfontSize),
                  textAlign: TextAlign.center,
                  onFieldSubmitted: (item) {
                    _formKey.currentState.save();

                    if (_formKey.currentState.validate()) {
                      auth.signInAnonyms();
                      pageController.nextPage(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeIn);
                    }
                  },
                  decoration: kTextFieldDecoration),
            ),
          ),
        ],
      ),
    );
  }
}

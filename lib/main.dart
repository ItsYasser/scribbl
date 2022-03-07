// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scribble/View/PaintScreen.dart';

import 'package:scribble/constants.dart';

import 'Util/bindings.dart';
import 'View/Main/mainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DataBindings().dependencies();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Scribbl',
        home: MainScreen(),
        // home: PaintScreen(),
        initialBinding: DataBindings(),
        theme: ThemeData(
          scaffoldBackgroundColor: kBackGroundColor,
          fontFamily: 'upheavtt',
          primaryColor: kOrange,
        ));
  }
}

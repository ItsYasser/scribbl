// ignore_for_file: annotate_overrides, empty_catches, avoid_print, prefer_final_fields, file_names

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/userModel.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel user = UserModel("", "", "", 0);

  void onInit() async {
    signInAnonyms();
  }

  void signInAnonyms() async {
    await _auth.signInAnonymously().then((value) => user.id = value.user.uid);
  }
}

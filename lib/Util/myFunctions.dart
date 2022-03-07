import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scribble/View/PaintScreen.dart';
import 'package:scribble/View/loadingScreen.dart';

Future<dynamic> circularDialog() {
  return Get.dialog(
    const Center(
      child: CircularProgressIndicator(),
    ),
    barrierDismissible: false,
  );
}

void loadingScreen({Future<dynamic> theAsyncFunc, Widget nextPage}) async {
  Get.to(() => LoadingPage());
  await theAsyncFunc.then((value) {
    if (value == true) {
      Get.off(PaintScreen());
    } else {}
  });
}

dynamic getListMap(List<dynamic> items) {
  if (items == null) {
    return null;
  }
  List<Map<String, dynamic>> list = [];
  items.forEach((element) {
    list.add(element.toJson());
  });
  return list;
}

SnackbarController snackBar(
    {String title,
    String message,
    Color titleColor = Colors.red,
    SnackPosition snackPosition = SnackPosition.BOTTOM}) {
  return Get.snackbar("", '',
      backgroundColor: Colors.black.withOpacity(.9),
      borderRadius: 10,
      titleText: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: titleColor, fontSize: 18),
      ),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      snackPosition: snackPosition,
      colorText: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10));
}

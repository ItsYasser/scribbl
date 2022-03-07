import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scribble/Controllers/AuthController.dart';

class AvatarSelecter extends StatefulWidget {
  @override
  State<AvatarSelecter> createState() => _AvatarSelecterState();
}

class _AvatarSelecterState extends State<AvatarSelecter> {
  int selectedAvatar = 0;

  List<String> avatars = ['Boy', 'Girl', 'The rock'];
  AuthController auth = Get.find<AuthController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.user.avatar = avatars[selectedAvatar];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 200,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        item((selectedAvatar + 1) % 3),
        item(selectedAvatar),
        item((selectedAvatar - 1) % 3),
      ]),
    );
  }

  Widget item(int index) {
    bool selected = index == selectedAvatar;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatar = index;
          auth.user.avatar = avatars[selectedAvatar];
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SvgPicture.asset(
          "assets/images/${avatars[index]}.svg",
          height: selected ? 160 : 80,
        ),
      ),
    );
  }
}

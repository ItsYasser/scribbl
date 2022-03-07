import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/RoomController.dart';
import '../../../constants.dart';

class MessageField extends StatefulWidget {
  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  RoomController roomController = Get.find<RoomController>();

  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            roomController.msg = value;
          },
        )),
        IconButton(
          onPressed: () {
            roomController.sendMessage();
            textEditingController.clear();
          },
          icon: Icon(Icons.arrow_forward),
        )
      ],
    );
  }
}

class Chat extends StatelessWidget {
  RoomController roomController = Get.find<RoomController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: roomController.chatStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final doc = snapshot.data;
          return Container(
            height: size.height * 0.71,
            width: size.width * 0.52,
            child: ListView.builder(
                itemCount: doc?.docs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data?.docs[index];
                  return MessageContainer(
                    key: Key(ds['id']),
                    name: ds['senderName'],
                    msg: ds['msg'],
                  );
                }),
          );
        });
  }
}

class MessageContainer extends StatelessWidget {
  final String name, msg;

  const MessageContainer({Key key, this.name, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      height: size.height * 0.1,
      width: double.infinity,
      color: kMsgColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BorderedText(
            strokeColor: Colors.black,
            strokeWidth: 4,
            child: Text(
              name,
              style: TextStyle(color: Colors.red),
            )),
        SizedBox(
          height: 10,
        ),
        BorderedText(
            strokeColor: Colors.black,
            strokeWidth: 4,
            child: Text(
              msg,
              softWrap: false,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            )),
      ]),
    );
  }
}

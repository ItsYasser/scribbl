import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scribble/Util/firebase_user.dart';

import 'package:scribble/View/Main/components/chat.dart';

import '../../../Models/userModel.dart';
import '../../../constants.dart';

class PlayersTile extends StatefulWidget {
  final List<UserModel> players;
  final String selectedPlayerId;

  const PlayersTile({Key key, this.players, this.selectedPlayerId})
      : super(key: key);
  @override
  State<PlayersTile> createState() => _PlayersTileState();
}

class _PlayersTileState extends State<PlayersTile> {
  bool opened = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kGreyColor,
            border: Border(
                top: BorderSide(width: 2),
                right: BorderSide(width: 2),
                left: BorderSide(width: 2)),
          ),
          width: opened ? size.width * 0.7 : size.width * 0.18,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * 0.71,
                    width: size.width * 0.17,
                    child: ListView.builder(
                      itemCount: widget.players.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => PlayerInfos(
                        points: widget.players[index].points,
                        avatar: widget.players[index].avatar,
                        name: widget.players[index].name,
                        id: widget.players[index].id,
                        selectedId: widget.selectedPlayerId,
                      ),
                    ),
                  ),
                  opened ? Chat() : SizedBox.shrink()
                ],
              ),
              opened
                  ? widget.selectedPlayerId == FireStoreUser.getUser().uid
                      ? SizedBox.shrink()
                      : Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            color: Colors.white,
                            child: MessageField(),
                          ),
                        )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: size.height * 0.08,
          width: size.width * 0.06,
          decoration: BoxDecoration(
            color: kGreyColor,
            border: Border(
              right: BorderSide(width: 2),
              top: BorderSide(width: 2),
              bottom: BorderSide(width: 2),
            ),
          ),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  opened = !opened;
                });
              },
              child: Icon(opened
                  ? Icons.arrow_back_ios_outlined
                  : Icons.arrow_forward_ios_outlined)),
        ),
      ],
    );
  }
}

class PlayerInfos extends StatelessWidget {
  final String avatar, name;
  final String id, selectedId;
  final int points;

  const PlayerInfos(
      {Key key, this.points, this.avatar, this.name, this.id, this.selectedId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //TODO: continue from here
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size.width * 0.17,
          color: id == selectedId
              ? Colors.blue.withOpacity(.4)
              : Colors.transparent,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(children: [
            BorderedText(
              strokeWidth: 2,
              strokeColor: Colors.black,
              child: Text(
                points.toString(),
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset(
                "assets/images/${avatar}.svg",
                height: size.width * 0.18,
              ),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 18),
            ),
          ]),
        ),
      ],
    );
  }
}

class RoomModel {
  String code, currentPainter = "", roomOwner;
  int currentRound, totalRounds;
  List<dynamic> players = [];
  bool didStart = false;
  String theAnswer = "";
  dynamic startAt;

  RoomModel(this.code, this.currentRound, this.players, this.totalRounds,
      this.roomOwner, this.startAt);
  RoomModel.fromJson(dynamic map) {
    if (map.isEmpty) {
      return;
    }
    startAt = map['startAt'];
    theAnswer = map['theAnswer'];

    currentPainter = map['currentPainter'];
    totalRounds = map['TotalRounds'];
    roomOwner = map['roomOwner'];
    code = map['code'];
    currentRound = map['currentRound'];
    players = map['players'];
    didStart = map['didStart'];
  }
  toJson() {
    return {
      // 'startAt': startAt,
      'startAt': startAt,
      'code': code,
      'didStart': didStart,
      'currentRound': currentRound,
      'players': players,
      'currentPainter': currentPainter,
      'TotalRounds': totalRounds,
      'theAnswer': theAnswer,
      'roomOwner': roomOwner,
    };
  }
}

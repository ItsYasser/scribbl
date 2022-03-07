import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String id, name, avatar;
  int points;

  UserModel(this.id, this.name, this.avatar, this.points);
  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if (map.isEmpty) {
      return;
    }
    id = map['id'];
    name = map['name'];
    avatar = map['avatar'];
    points = map['points'];
  }
  toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'points': points,
    };
  }
}

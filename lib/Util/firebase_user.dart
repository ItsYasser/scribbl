import 'package:firebase_auth/firebase_auth.dart';

class FireStoreUser {
  static User getUser() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User loggedinUser = auth.currentUser;
    return loggedinUser;
  }
}

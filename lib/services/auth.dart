import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  UserData _userFromFirebaseuser(User user) {
    return user != null ? UserData(user.uid) : null;
  }

  User get currentUser {
    return firebaseAuth.currentUser;
  }

  Future signInEmail(String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // print(result);
      var user = result.user;
      return _userFromFirebaseuser(user);
    } catch (ex) {
      // print(ex.message);
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}

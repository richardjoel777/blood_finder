import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _passcode = "";
  List _authemails = [];
  List _authmobs = [];

  UserData _userFromFirebaseuser(User user) {
    return user != null ? UserData(user.uid) : null;
  }

  User get currentUser {
    return firebaseAuth.currentUser;
  }

  String get passcode {
    return _passcode;
  }

  List get authemails {
    return [..._authemails];
  }

  List get authmobs {
    return [..._authmobs];
  }

  Future signupEmail(String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      return _userFromFirebaseuser(user);
      // print(result);
    } catch (ex) {
      print(ex.message);
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  Future<void> getPassCode() async {
    try {
      await FirebaseFirestore.instance
          .collection("admins")
          .doc("admins")
          .get()
          .then((doc) {
        _passcode = doc.data()["passcode"];
        print(_passcode);
        notifyListeners();
      });
    } catch (ex) {
      print(ex.message);
    }
  }

  // Future<void> getAuthUsers() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("admins")
  //         .doc("admins")
  //         .get()
  //         .then((doc) {
  //       _authemails = doc.data()["authemails"];
  //       _authmobs = doc.data()["authmobs"];
  //       print(_authemails);
  //       print(_authmobs);
  //       notifyListeners();
  //     });
  //   } catch (ex) {
  //     print(ex.message);
  //   }
  // }

  Future signInEmail(String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // print(result);
      var user = result.user;
      return _userFromFirebaseuser(user);
    } catch (ex) {
      print(ex.message);
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}

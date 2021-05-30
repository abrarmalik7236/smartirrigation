import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService(this._auth);
  Stream<User> get authStateChanges => _auth.idTokenChanges();
  Future<String> login(String email, String password, context) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
                print(value);
              });
      return "Logged in";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //    dialogbox(context, 'Sorry', 'No user found for that email.');
        dialogbox(context, 'Sorry', 'Password should be at least 6 characters');

        print('No user found for that email');
      } else if (e.code == 'wrong-password') {
        //   dialogbox(context, 'Sorry', 'Wrong password provided for that user.');
        dialogbox(context, 'Sorry', 'Wrong password provided for that user ');

        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> signUp(String email, String password, context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        dialogbox(context, 'Sorry', 'Password should be at least 6 characters');
      } else if (e.code == 'email-already-in-use') {
        dialogbox(context, 'Oh', 'Email is already in use');
      }
    } catch (e) {
      print(e);
    }
  }
}

dialogbox(context, title, desc) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.ERROR,
    animType: AnimType.RIGHSLIDE,
    headerAnimationLoop: false,
    title: '$title',
    desc: '$desc',
  )..show();
}

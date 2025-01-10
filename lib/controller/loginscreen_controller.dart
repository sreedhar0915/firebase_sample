import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/utils/Apputils.dart';
import 'package:flutter/material.dart';

class LoginscreenController with ChangeNotifier {
  bool isloading = false;
  Future<void> onLogin(
      {required String emailAddress,
      required String Passsword,
      required BuildContext context}) async {
    isloading = true;
    notifyListeners();
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: Passsword);
      log(credential.user?.email.toString() ?? "no data");
      AppUtils.showOnetimeSnackbar(
          context: context, bg: Colors.green, message: 'Login successful');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppUtils.showOnetimeSnackbar(
            context: context,
            bg: Colors.red,
            message: 'No user found for that email.');

        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        AppUtils.showOnetimeSnackbar(
            context: context,
            bg: Colors.red,
            message: 'Wrong password provided for that user.');

        print('Wrong password provided for that user.');
      }
    }
    isloading = false;
    notifyListeners();
  }
}

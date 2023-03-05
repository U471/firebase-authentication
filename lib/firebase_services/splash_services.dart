import 'dart:async';

import 'package:doctor_app/ui/auth/login_secreen.dart';
import 'package:doctor_app/ui/firestore/firestore_list_secreen.dart';
import 'package:doctor_app/ui/post/post_secreen.dart';
import 'package:doctor_app/ui/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (contex) => FireStoreSecreen())));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (contex) => LoginSecreen())));
    }
  }
}

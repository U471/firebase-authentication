import 'package:doctor_app/util/utils.dart';
import 'package:doctor_app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordSecreen extends StatefulWidget {
  const ForgotPasswordSecreen({super.key});

  @override
  State<ForgotPasswordSecreen> createState() => _ForgotPasswordSecreenState();
}

class _ForgotPasswordSecreenState extends State<ForgotPasswordSecreen> {
  TextEditingController forgotPasswordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: forgotPasswordController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Email', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 40,
            ),
            RoundButton(
                title: 'Forgot',
                onTap: () {
                  auth
                      .sendPasswordResetEmail(
                          email: forgotPasswordController.text.toString())
                      .then((value) {
                    Utils().toastMessageSuccess(
                        "we have sent you email to recover password,please check email");
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                }),
          ],
        ),
      ),
    );
  }
}

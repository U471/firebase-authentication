import 'package:doctor_app/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashSecreen extends StatefulWidget {
  const SplashSecreen({super.key});

  @override
  State<SplashSecreen> createState() => _SplashSecreenState();
}

class _SplashSecreenState extends State<SplashSecreen> {
  @override
  SplashServices splashservices = SplashServices();
  void initState() {
    // TODO: implement initState
    super.initState();
    splashservices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Firebase",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

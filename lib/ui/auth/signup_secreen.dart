import 'package:doctor_app/ui/auth/login_secreen.dart';
import 'package:doctor_app/util/utils.dart';
import 'package:doctor_app/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupSecreen extends StatefulWidget {
  const SignupSecreen({super.key});

  @override
  State<SignupSecreen> createState() => _SignupSecreenState();
}

class _SignupSecreenState extends State<SignupSecreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Passwords',
                          prefixIcon: Icon(Icons.password)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            const SizedBox(height: 50),
            RoundButton(
                title: "Sign Up",
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                }),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginSecreen()));
                    },
                    child: Text("Login")),
              ],
            )
          ],
        ),
      ),
    );
  }

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      // print(value.user!.uid);
      // print("error=>${value.toString()}");
      Utils().toastMessageSuccess("Successfully SignUp");
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      String message = error.toString();
      List<String> parts = message.split("] ");
      print(parts[1]);
      // print("error=>${error.}");
      Utils().toastMessage(parts[1]);
      setState(() {
        loading = false;
      });
    });
  }
}

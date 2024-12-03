import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:usersbyd_app/authentication/login_screen.dart';
import 'package:usersbyd_app/methods/common_methods.dart';
import 'package:usersbyd_app/pages/home_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    CommonMethods().checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation() {
    if (usernameTextEditingController.text.trim().length < 2) {
      cMethods.displaySnackBar("Fill the details correctly", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Enter proper email address", context);
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.toString(),
      password: passwordTextEditingController.text.toString(),
    )
            .catchError((errorMsg) {
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }))
        .user;
    FirebaseFirestore.instance.collection("users").doc(userFirebase!.uid).set({
      "id":userFirebase.uid,
      "name":usernameTextEditingController.text.trim(),
      "email":emailTextEditingController.text.trim(),
      "pass":passwordTextEditingController.text.trim(),
      "blockStatus":"no",
    }).then((value){
      log("Data Inserted");
    });


    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap = {
      "id":userFirebase.uid,
      "name":usernameTextEditingController.text.trim(),
      "email":emailTextEditingController.text.trim(),
      "pass":passwordTextEditingController.text.trim(),
      "blockStatus":"no",
    };
    usersRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
  }

  // registerNewUser(
  //     {required String email,
  //     required String password,
  //     required String username}) async {
  //   if (email == "" || password == "" || username == "") {
  //     log("Enter Required Field");
  //   } else {
  //     UserCredential? userCredential;
  //     try {
  //       userCredential = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(email: email, password: password);
  //       log("User Created");
  //     } on FirebaseAuthException catch (ex) {
  //       return log(ex.code.toString());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WELCOME TO!!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Text(
              'Book Your Driver',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Create Your Account !!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: usernameTextEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "User Name",
                  labelStyle: TextStyle(
                    fontSize: 14,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: TextStyle(
                    fontSize: 14,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordTextEditingController,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    fontSize: 14,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                registerNewUser();
                //checkIfNetworkIsAvailable();
                // registerNewUser(
                //     email: emailTextEditingController.text.toString(),
                //     password: passwordTextEditingController.text.toString(),
                //     username: usernameTextEditingController.text.toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 80),
              ),
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => LoginScreen(),
                  ),
                );
              },
              child: Text('Already have an Account? Login Here!!'),
            ),
          ],
        ),
      ),
    );
  }
}

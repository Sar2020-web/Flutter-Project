import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:usersbyd_app/authentication/signup_screen.dart';
import 'package:usersbyd_app/global/global_var.dart';
import 'package:usersbyd_app/methods/common_methods.dart';
import 'package:usersbyd_app/pages/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    CommonMethods().checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
     if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Enter proper email address", context);
    } else if(passwordTextEditingController.text.trim().length<5)
    {
      cMethods.displaySnackBar('Enter correct passowrd', context);
    }else{
       signInUser();
     }
  }

  signInUser() async{
    final User? userFirebase = (await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailTextEditingController.text.toString(),
      password: passwordTextEditingController.text.toString(),
    )
        .catchError((errorMsg) {
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }))
        .user;

    if(userFirebase != null){
      DatabaseReference usersRef =
      FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
      await usersRef.once().then((snap)
      {
        if(snap.snapshot.value != null)
        {
          if((snap.snapshot.value as Map)["blockStatus"] == "no"){
            username = ((snap.snapshot.value as Map)["name"]);
            Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
          }else{
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Contact to Administration", context);
          }
        }else{
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar("Invalid details", context);
        }
      });
    }

  }

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
            Text('WELCOME TO!!', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500),),
            Text('Book Your Driver', style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700),),
            SizedBox(height: 10,),
            Text('Login Here !!',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "Enter Your Email ",
                  labelStyle: TextStyle(
                    fontSize: 14,
                  )
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: passwordTextEditingController,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    fontSize: 14,
                  )
              ),
            ),
            SizedBox(height: 10,),

            ElevatedButton(
              onPressed: (){
                signInFormValidation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 80),
              ),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> SignupScreen(),
                ),
                );
              },
              child: Text('Create New Account? Register Here!!'),
            ),
          ],

        ),
      ),
    );
  }
}

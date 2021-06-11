import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scan_in/auth_stuff/sign_up.dart';
import 'package:scan_in/tabs/homepage.dart';

class AuthWrap extends StatelessWidget {
  const AuthWrap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong, please try again!"),
              );
            } else if (snapshot.hasData) {
              return HomePage();
            } else {
              return SignUp();
            }
          },
        ),
      );
}

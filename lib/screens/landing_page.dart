import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fooodify/screens/home_page.dart';
import 'package:fooodify/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, Snapshot) {
        if (Snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Container(
                child: Text(
                  ('Error: ${Snapshot.error}'),
                ),
              ),
            ),
          );
        }
        if (Snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Container(
                      child: Text(
                        ('Error: ${Snapshot.error}'),
                      ),
                    ),
                  ),
                );
              }
              if (streamSnapshot.connectionState == ConnectionState.active) {
                User _user = streamSnapshot.data;
                if (_user == null) {
                  return LoginScreen();
                } else {
                  return HomePage();
                }
              }
              return Scaffold(
                body: Center(
                  child: Container(
                    child: Text(
                      ('Foodify'),
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(
            child: Container(
              child: Text(
                ('Initializing...'),
              ),
            ),
          ),
        );
      },
    );
  }
}

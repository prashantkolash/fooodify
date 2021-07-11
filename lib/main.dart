import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fooodify/screens/landing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          accentColor: Color(0xff02D859),
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          )),
      home: LandingPage(),
    );
  }
}

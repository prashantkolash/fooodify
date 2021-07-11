import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fooodify/screens/cart_page.dart';

class ActionBar extends StatelessWidget {
  final String title;
  final bool hasArrow;
  final double x;
  final double y;
  ActionBar({this.title, this.hasArrow, this.x, this.y});
  CollectionReference _userReference =
      FirebaseFirestore.instance.collection('Users');
  User _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    bool _hasArrow = hasArrow ?? false;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(y),
          Colors.white.withOpacity(x),
        ],
        begin: Alignment(0, 0),
        end: Alignment(0, 2),
      )),
      padding: EdgeInsets.only(
        left: 15,
        top: 30,
        right: 15,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Icon(Icons.menu),
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w900,
                fontSize: 24,
                fontFamily: 'Montserrat'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
            child: Container(
                alignment: Alignment(0, 0),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: StreamBuilder(
                  stream: _userReference
                      .doc(_user.uid)
                      .collection("Cart")
                      .snapshots(),
                  builder: (context, snapshot) {
                    int _totalItems = 0;
                    if (snapshot.connectionState == ConnectionState.active) {
                      List _documents = snapshot.data.docs;
                      _totalItems = _documents.length;
                    }
                    return Text(
                      '${_totalItems}',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}

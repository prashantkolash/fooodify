import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooodify/action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooodify/screens/product_card.dart';
import 'product_page.dart';

class HomeTab extends StatelessWidget {
  CollectionReference _productReference =
      FirebaseFirestore.instance.collection('Products');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productReference.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Container(
                      child: Text(
                        ('Error: ${snapshot.error}'),
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                    padding: EdgeInsets.only(
                      top: 80,
                      bottom: 8,
                    ),
                    children: snapshot.data.docs.map((document) {
                      return ProductCard(
                        productId: document.id,
                        price: document['price'],
                        name: document['name'],
                        imageurl: document['image'],
                      );
                    }).toList());
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          ActionBar(
            title: 'Home',
            hasArrow: false,
            x: 1,
            y: 1,
          ),
        ],
      ),
    );
  }
}

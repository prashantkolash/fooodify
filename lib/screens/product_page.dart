import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooodify/action_bar.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  CollectionReference _productReference =
      FirebaseFirestore.instance.collection('Products');
  CollectionReference _userReference =
      FirebaseFirestore.instance.collection('Users');
  User _user = FirebaseAuth.instance.currentUser;
  Future _addToCart() {
    return _userReference
        .doc(_user.uid)
        .collection('Cart')
        .doc(widget.productId)
        .set({"qty": 0});
  }

  final SnackBar _snackBar = SnackBar(content: Text("Item added to Cart"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _productReference.doc(widget.productId).get(),
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
                Map<String, dynamic> docData = snapshot.data.data();
                return ListView(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                  children: [
                    Container(
                      child: Image.network(docData['image']),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 30, 18, 10),
                      child: Container(
                        child: Text(
                          '${docData['name']}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontFamily: 'MontBold',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 30, 18, 0),
                      child: Container(
                        child: Text(
                          '\$${docData['price'].toString()}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Theme.of(context).accentColor,
                              fontFamily: 'MontBold',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 2),
                      child: Container(
                        child: Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontFamily: 'MontBold',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 5, 18, 10),
                      child: Container(
                        child: Text(
                          '${docData['description']}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 15, right: 15),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(150)),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _addToCart();
                            Scaffold.of(context).showSnackBar(_snackBar);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add To Cart',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.shopping_cart),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).accentColor,
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          ActionBar(
            title: "",
            hasArrow: true,
            x: 0,
            y: 0,
          ),
        ],
      ),
    );
  }
}

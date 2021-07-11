import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fooodify/screens/product_page.dart';
import 'package:toast/toast.dart';
import '../action_bar.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CollectionReference _userReference =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference _productReference =
      FirebaseFirestore.instance.collection('Products');
  User _user = FirebaseAuth.instance.currentUser;
  int total = 0;
  Razorpay _razorpay;

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_dFpFaAhgfSJvej',
      'amount': (total) * 100,
      'name': _user.displayName,
      'description': 'Payment',
      'prefill': {'contact': '', 'email': _user.email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Toast.show('Success ' + response.paymentId, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Toast.show("Error " + response.code.toString(), context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Toast.show('External Wallet ' + response.walletName, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ActionBar(
            title: "Cart",
            hasArrow: true,
            x: 1,
            y: 1,
          ),
          FutureBuilder<QuerySnapshot>(
            future: _userReference.doc(_user.uid).collection("Cart").get(),
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
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductPage(productId: document.id)));
                          },
                          child: FutureBuilder(
                            future: _productReference.doc(document.id).get(),
                            builder: (context, cartSnapshot) {
                              if (cartSnapshot.hasError) {
                                return Center(
                                  child: Container(
                                    child: Text('${cartSnapshot.error}'),
                                  ),
                                );
                              }
                              if (cartSnapshot.connectionState ==
                                  ConnectionState.done) {
                                Map _productMap = cartSnapshot.data.data();
                                total = total + _productMap['price'];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            "${_productMap['image']}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${_productMap['name']}",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                "\$${_productMap['price']}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ));
                    }).toList());
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 620, left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total  \$${total}',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                    onPressed: () {
                      openCheckout();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor,
                        onPrimary: Colors.white),
                    child: Text('Pay')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

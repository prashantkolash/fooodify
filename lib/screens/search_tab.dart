import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooodify/screens/product_card.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  CollectionReference _productReference =
      FirebaseFirestore.instance.collection('Products');

  String _searchFood;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: SizedBox(
              height: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 50),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: TextField(
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _searchFood = value.toLowerCase();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'SEARCH',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 125, bottom: 15, left: 130),
            child: Text(
              'Search Results',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: FutureBuilder<QuerySnapshot>(
              future: _productReference
                  .orderBy("searchString")
                  .startAt([_searchFood]).endAt(['$_searchFood\uf8ff']).get(),
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
          ),
        ],
      ),
    );
  }
}

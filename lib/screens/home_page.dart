import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooodify/BottomTabs.dart';
import 'package:fooodify/constants.dart';
import 'package:fooodify/screens/home_tab.dart';
import 'package:fooodify/screens/search_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _tabsPageController;
  int _tabSelected = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabsPageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabsPageController.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('FOODIFY'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Center(
                  child: Text(
                'FOODIFY',
                style: TextStyle(
                    fontFamily: 'MontBold',
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              )),
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              controller: _tabsPageController,
              onPageChanged: (num) {
                setState(() {
                  _tabSelected = num;
                });
              },
              children: [
                HomeTab(),
                SearchTab(),
              ],
            ),
          ),
          BottomTabs(
            selectedTab: _tabSelected,
            tabClicked: (num) {
              setState(() {
                _tabsPageController.animateToPage(
                  num,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInCubic,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

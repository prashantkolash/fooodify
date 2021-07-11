import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  BottomTabs({this.selectedTab, this.tabClicked});
  Function(int) tabClicked;
  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab;
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomBtn(
            image: 'images/baseline_home_black_24dp.png',
            selected: _selectedTab == 0 ? true : false,
            onPressed: () {
              setState(() {
                widget.tabClicked(0);
              });
            },
          ),
          BottomBtn(
            image: 'images/baseline_search_black_24dp.png',
            selected: _selectedTab == 1 ? true : false,
            onPressed: () {
              setState(() {
                widget.tabClicked(1);
              });
            },
          ),
        ],
      ),
    );
  }
}

class BottomBtn extends StatelessWidget {
  String image;
  bool selected;
  Function onPressed;
  BottomBtn({this.image, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: _selected ? Theme.of(context).accentColor : Colors.transparent,
          width: 2.0,
        ))),
        padding: EdgeInsets.all(8.0),
        width: 50,
        height: 50,
        child: Image.asset(
          image,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}

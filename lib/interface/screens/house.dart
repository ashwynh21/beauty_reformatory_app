import 'package:beautyreformatory/interface/elements/navigation_bar.dart';
import 'package:beautyreformatory/interface/elements/status_bar.dart';
import 'package:flutter/material.dart';

class House extends StatefulWidget {
  _HouseState state;

  House({Key key}) : super(key: key);

  @override
  _HouseState createState() {
    state = _HouseState();
    return state;
  }
}

class _HouseState extends State<House> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,

        child: Stack(
          children: <Widget>[
            StatusBar(),

            /*
            Content will be managed in this containment below.
             */
            Container(),

            NavigationBar(),
          ],
        )
      ),
    );
  }
}
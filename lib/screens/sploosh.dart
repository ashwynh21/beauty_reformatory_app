import 'package:beautyreformatory/elements/background.dart';
import 'package:beautyreformatory/elements/start.dart';
import 'package:flutter/material.dart';

class Sploosh extends StatefulWidget {
  Sploosh({Key key}) : super(key: key);

  @override
  _SplooshState createState() => _SplooshState();
}

class _SplooshState extends State<Sploosh> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Background(),
          Start(),
        ],
      ),
    );
  }
}
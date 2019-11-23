import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class Start extends StatefulWidget {
  _StartState state;

  @override
  State<StatefulWidget> createState() {
    state = new _StartState();
    return state;
  }
}

class _StartState extends State<Start> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      child: Container(


        child: FlareActor('lib/assets/flares/logo.flr', fit: BoxFit.contain, animation: 'show')
      )
    );
  }

}
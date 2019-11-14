import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

// ignore: must_be_immutable
class Background extends StatefulWidget {
  String animation;

  Background({Key key,
    this.animation = 'start',
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {

  @override
  Widget build(BuildContext context) {
    var utilities;
    return Stack(
      children: <Widget>[
        Container(
            color: utilities.colors.white
        ),
        Container(
            width: MediaQuery.of(context).size.width,

            child: FlareActor('lib/assets/flares/top_wave.flr', animation: widget.animation, fit: BoxFit.contain, alignment: Alignment.topCenter,)
        ),
      ],
    );
  }
}
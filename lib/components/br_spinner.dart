import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class BrSpinner extends StatefulWidget {
  BrSpinner({Key key}) : super(key: key);

  @override
  _BrSpinnerState createState() => _BrSpinnerState();
}

class _BrSpinnerState extends State<BrSpinner> {
  String animation = 'active';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,

      child: FlareActor('lib/assets/flares/spinner.flr', fit: BoxFit.contain, animation: animation,)
    );
  }

}
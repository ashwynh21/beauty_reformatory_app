import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class BrSpinner extends StatefulWidget {
  _BrSpinnerState state;

  BrSpinner({Key key}) : super(key: key);

  @override
  _BrSpinnerState createState() {
    state = new _BrSpinnerState();
    return state;
  }

  Future show(bool show) async {
    show
        ?
        state.animate(show)
        :
        await Future.delayed(Duration(milliseconds: 480), () {
          state.animate(show);
        });
  }
}

class _BrSpinnerState extends State<BrSpinner> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 400),
      width: 28,
      height: 28,
      bottom: 128 + MediaQuery.of(context).viewInsets.bottom,

        child: AnimatedOpacity(
          duration: Duration(milliseconds: 400),
          opacity: (show) ? 1.0 : 0,
          child: FlareActor('lib/interface/assets/flares/spinner.flr', fit: BoxFit.contain, animation: show ? 'active' : 'idle',),
      )
    );
  }

  void animate(bool s) {
    setState(() {
      show = s;
    });
  }
}
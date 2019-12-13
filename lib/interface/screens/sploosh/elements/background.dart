
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class Background extends StatefulWidget {
  _BackgroundState state;

  String animation;
  void Function(String) onchange;

  Background({Key key,
    this.onchange,
    this.animation = 'start',
  }) : super(key: key);

  @override
  _BackgroundState createState() {
    state = _BackgroundState();
    return state;
  }
}

class _BackgroundState extends State<Background> {

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2400), () {
      setState(() {
        widget.animation = 'up';
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(
          color: resources.colors.white,
        ),
        Container(
          alignment: Alignment.bottomCenter,

          child: AnimatedOpacity(
            duration: Duration(milliseconds: 480),
            opacity: (widget.animation == 'ambient') ? 1 : 0,

            child: SvgPicture.asset('lib/interface/assets/images/wallpaper.svg',
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width - 104,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,

          child: FlareActor('lib/interface/assets/flares/top_wave.flr',
            animation: widget.animation,
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            callback: (String animation) {
              if(animation == 'up')
                setState(() {
                  widget.animation = 'ambient';

                  if(widget.onchange != null)
                    widget.onchange(animation);
                });
            },
          )
        ),
      ],
    );
  }
}
import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:beautyreformatory/utilities/utilities.dart';

class BrIconButton extends StatefulWidget {
  _BrIconButtonState state;

  String src;
  Color background, color;
  double elevation, padding;
  Function(Widget) click;

  BrIconButton({Key key,
    @required this.src,
    @required this.click,
    this.padding = 0,
    this.elevation = 4,
    this.background,
    this.color,
  }) : super(key: key);

  @override
  _BrIconButtonState createState() {
    state = _BrIconButtonState();
    return state;
  }
}

class _BrIconButtonState extends State<BrIconButton> {
  String animation = 'in';

  @override
  Widget build(BuildContext context) {
    return  MaterialButton(
        height: 44,
        minWidth: 44,
        padding: EdgeInsets.all(widget.padding.toDouble()),
        color: widget.background,
        splashColor: utilities.colors.light.withOpacity(0.24),
        highlightColor: utilities.colors.light.withOpacity(0.08),
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(22.0)),
        onPressed: () {
          if (widget.src.substring(widget.src.lastIndexOf('.') + 1, widget.src.length) == 'flr') {
            setState(() {
              animation = 'active';
            });

            Timer(const Duration(milliseconds: 1000), () {
              setState(() {
                animation = 'idle';
              });
            });
          }
          widget.click(widget);
        },

        child: Center(
          child: Container(
              width: 28,
              height:28,
              child: icon(widget.src)
          ),
        )
    );
  }

  Widget icon(String icon) {
    if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'svg' ) {
      return SvgPicture.asset(icon, color: widget.color);
    } else if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'flr') {
      return FlareActor(icon, alignment: Alignment.center, fit: BoxFit.contain, animation: animation, color: widget.color);
    }

    return Image.asset(widget.src,
        width: 22);
  }
}
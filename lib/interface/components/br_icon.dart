import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BrIcon extends StatefulWidget {
  String src;
  Color color;
  Function(Widget) click;

  BrIcon({Key key,
    @required this.src,
    @required this.click,
    @required this.color,
  }) : super(key: key);

  @override
  _BrIconState createState() => _BrIconState();
}

class _BrIconState extends State<BrIcon> {
  String animation = 'in';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: MaterialButton(
          padding: EdgeInsets.all(9),
          splashColor: widget.color.withOpacity(0.12),
          highlightColor: widget.color.withOpacity(0.24),
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
          child: Container(height: 32, width: 32, child: icon(widget.src)),
        ),
      ),
    );
  }

  Widget icon(String icon) {
    if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'svg' ) {
      return SvgPicture.asset(icon, color: widget.color);
    } else if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'flr') {
      return FlareActor(icon, alignment: Alignment.center, fit: BoxFit.contain, animation: animation, color: widget.color);
    }

    return Image.asset(icon,
        width: 22);
  }
}
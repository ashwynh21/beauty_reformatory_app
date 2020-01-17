import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BrIconButton extends StatefulWidget {
  _BrIconButtonState state;

  String src;
  Color background, color;
  double elevation, padding, size, radius;
  Function(Widget) click;

  BrIconButton({Key key,
    @required this.src,
    @required this.click,
    this.padding = 0,
    this.elevation = 4,
    this.background,
    this.color,
    this.size = 44,
    this.radius = 22,
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
    return  Container(
      width: widget.size,
      height: widget.size,
      child: MaterialButton(
          height: widget.size,
          minWidth: widget.size,
          padding: EdgeInsets.all(widget.padding.toDouble()),
          color: widget.background,
          splashColor: (widget.color != null) ? widget.color.withOpacity(0.24) : null,
          highlightColor: (widget.color != null) ? widget.color.withOpacity(0.08) : null,
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(widget.radius)),
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

          child: Align(
            alignment: Alignment.center,
            child: Container(
                height: widget.size / 1.5,
                width: widget.size / 1.5,
                child: icon(widget.src)
            ),
          )
      ),
    );
  }

  Widget icon(String icon) {
    if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'svg' ) {
      return SvgPicture.asset(icon, color: widget.color, width: widget.radius);
    } else if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'flr') {
      return FlareActor(icon, alignment: Alignment.center, fit: BoxFit.contain, animation: animation, color: widget.color);
    }

    return Image.asset(widget.src,
        width: 22);
  }
}
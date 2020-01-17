import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BrIcon extends StatefulWidget {
  String src;
  Color color, background;
  double size;
  Function(Widget) click;

  BrIcon({Key key,
    @required this.src,
    @required this.click,
    this.color,
    this.background,
    this.size = 38
  }) : super(key: key);

  @override
  _BrIconState createState() => _BrIconState();
}

class _BrIconState extends State<BrIcon> {
  String animation = 'idle';

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
        child: SizedBox(
          width: widget.size,
          height: widget.size,

          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: MaterialButton(
              padding: EdgeInsets.all(9),
              splashColor: (widget.color != null) ? widget.color.withOpacity(0.12) : null,
              highlightColor: (widget.color != null) ? widget.color.withOpacity(0.24) : null,
              color: widget.background,

              onPressed: () {
                widget.click(widget);
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
              },
              child: Container(child: icon(widget.src)),
            ),
          ),
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
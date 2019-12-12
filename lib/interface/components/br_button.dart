import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_svg/svg.dart';

class BrButton extends StatefulWidget {
  _BrButtonState state;

  String title, icon;
  Color background, color;
  int elevation, fontSize;
  double height;
  Function(BrButton) click;

  BrButton({Key key,
    this.title = '',
    this.icon,
    this.color,
    this.background,
    this.elevation = 4,
    this.height = 44,
    this.fontSize = 16,
    @required this.click,
  }) : super(key: key);

  @override
  _BrButtonState createState() {
    state = _BrButtonState();
    return state;
  }
}

class _BrButtonState extends State<BrButton> {
  @override
  Widget build(BuildContext context) {
    return
      MaterialButton(
        height: this.widget.height,
        minWidth: MediaQuery.of(context).size.width,

        color: this.widget.background,
        splashColor: resources.colors.light.withOpacity(0.24),
        highlightColor: resources.colors.light.withOpacity(0.08),
        elevation: this.widget.elevation.toDouble(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        onPressed: () async {

          this.widget.click(this.widget);
        },

        child: Container(
          margin: EdgeInsets.only(left: ((widget.icon == null) ? 16 : 4), right: ((widget.icon == null) ? 16 : 4), bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: (widget.icon != null) ? <Widget>[
              Container(height: widget.height - 20, width: widget.height - 20, child: icon(widget.icon)),
              Text(
                this.widget.title,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: this.widget.fontSize.toDouble(),
                  fontWeight: FontWeight.w400,
                  color: this.widget.color
                )
              ),
            ]
            : <Widget>[
              Text(
                  this.widget.title,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: this.widget.fontSize.toDouble(),
                      fontWeight: FontWeight.w400,
                      color: this.widget.color
                  )
              ),
            ],
          ),
        ),
      );
  }

  Widget icon(String icon) {
    if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'svg' ) {
      return SvgPicture.asset(icon, color: widget.color);
    } else if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'flr') {
      return FlareActor(icon, alignment: Alignment.center, fit: BoxFit.contain, animation: 'idle', color: widget.color);
    }

    return Image.asset(icon,
        width: 22);
  }
}
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_svg/svg.dart';

class BrButton extends StatefulWidget {
  _BrButtonState state;
  bool network;

  String title, icon;
  Color background, color;
  int elevation, fontSize;
  double height;
  Future Function(BrButton) click;

  BrButton({Key key,
    this.title = '',
    this.icon,
    this.color,
    this.background,
    this.elevation = 4,
    this.height = 44,
    this.fontSize = 16,
    this.network = false,
    @required this.click,
  }) : super(key: key);

  @override
  _BrButtonState createState() {
    state = _BrButtonState();
    return state;
  }
}

class _BrButtonState extends State<BrButton> {
  bool clicked = false;
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

          setState(() {
            clicked = true;
          });

          this.widget.click(this.widget).then((_) {

            Future.delayed(Duration(seconds: 1), () {

              setState(() {
                clicked = false;
              });
            });
          });
        },

        child: Container(
          margin: EdgeInsets.only(left: ((widget.icon == null) ? 16 : 4), right: ((widget.icon == null) ? 16 : 4), bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: (widget.icon != null) ? <Widget>[
              Container(height: widget.height - 20, width: widget.height - 20, child: icon(widget.icon)),

              networking(widget.network && clicked),
            ]
            : <Widget>[
              networking(widget.network && clicked),
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

  Widget networking(bool value) {
    return (!value)
        ?
        Text(
            this.widget.title,
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontSize: this.widget.fontSize.toDouble(),
                fontWeight: FontWeight.w400,
                color: this.widget.color
            )
        )
        :
        Container(
          height: 24,
          width: 24,
            child: FlareActor('lib/interface/assets/flares/spinner.flr',
            fit: BoxFit.contain,
            animation: 'active',
            color: Colors.white,
            )
        );
  }
}
import 'package:beautyreformatory/utilities/utilities.dart';
import 'package:flutter/material.dart';

class BrButton extends StatefulWidget {
  _BrButtonState state;

  String title;
  Color background, color;
  int elevation, fontSize;
  double height;
  Function(BrButton) click;

  BrButton({Key key,
    this.title = '',
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
        splashColor: utilities.colors.light.withOpacity(0.24),
        highlightColor: utilities.colors.light.withOpacity(0.08),
        elevation: this.widget.elevation.toDouble(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        onPressed: () async {

          this.widget.click(this.widget);
        },

        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          child: new Text(
              this.widget.title,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: this.widget.fontSize.toDouble(),
                  fontWeight: FontWeight.w400,
                  color: this.widget.color
              )
          ),
        ),
      );
  }
}
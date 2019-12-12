import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';

class BrSnack extends StatefulWidget {
  _BrSnackState state;

  String text;

  BrSnack({Key key,
    this.text = ''
  }) : super(key: key);

  @override
  _BrSnackState createState() {
    state = _BrSnackState();
    return state;
  }

  void show(String text) {
    state.popup(text);
  }
}

class _BrSnackState extends State<BrSnack> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      width: MediaQuery.of(context).size.width,
      left: (show) ? 0 : MediaQuery.of(context).size.width,
      bottom: 48,
      child: Opacity(
        opacity: 0.64,
        child: Container(
          alignment: Alignment.bottomCenter,

          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(32.0),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.0),

              child: Material(
                color: resources.colors.primary,

                child: InkWell(
                  splashColor: resources.colors.light.withOpacity(0.24),
                  highlightColor: resources.colors.light.withOpacity(0.08),
                  onTap: () {
                    setState(() {
                      show = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),

                    child: Text(widget.text,
                        style: TextStyle(
                          color: resources.colors.white,
                          fontSize: 12,
                        ),
                      ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void popup(String text) {
    setState(() {
      widget.text = text;
      show = true;
    });
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        show = false;
      });
    });
  }
}
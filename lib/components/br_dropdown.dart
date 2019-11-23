import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/utilities.dart';

class BrDropdown extends StatefulWidget {
  double height;
  String icon;

  BrDropdown({Key key,
    this.height = 60,
    this.icon,
  }) : super(key: key);

  @override
  _BrDropdownState createState() => _BrDropdownState();
}

class _BrDropdownState extends State<BrDropdown> {
  Color color = utilities.colors.primary.withOpacity(0.48);
  String animation = 'idle';
  FocusNode focus = new FocusNode();

  @override
  void initState() {
    focus.addListener(() {
      if(focus.hasFocus) {
        setState(() {
          color = utilities.colors.primary;
          animation = 'active';
        });
      } else {
        setState(() {
          color = utilities.colors.primary.withOpacity(0.48);
          animation = 'idle';
        });
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Container(
            height: widget.height,
            child: Flex(
              direction: Axis.horizontal,

              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 28,
                        height: 28,
                        child: icon(widget.icon)
                    ),
                  ),
                ),

                Expanded(
                  flex: 6,
                  child: Container(
                    height: widget.height,
                    margin: EdgeInsets.only(left: 12),


                  ),
                ),
              ],
            )
          ),
          Container(
            height: 1.6,

            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1),
            ),
          )
        ],
      )
    );
  }

  Widget icon(String icon) {
    if(icon != null) {
      return Container(height: 32, width: 32, child: FlareActor(icon, animation: animation, color: color,));
    } else {
      return Container();
    }
  }
}
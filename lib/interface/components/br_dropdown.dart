import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class BrDropdown extends StatefulWidget {
  double height;
  String icon, hint, value;
  List<String> items;

  BrDropdown({Key key,
    this.height = 60,
    this.icon,
    this.hint = '',
    this.value = '',
    @required this.items,
  }) : super(key: key);

  @override
  _BrDropdownState createState() => _BrDropdownState();
}

class _BrDropdownState extends State<BrDropdown> {
  Color color = resources.colors.primary.withOpacity(0.48);
  String animation = 'idle';
  FocusNode focus = new FocusNode();

  @override
  void initState() {
    widget.value = widget.hint;

    focus.addListener(() {
      if(focus.hasFocus) {
        setState(() {
          color = resources.colors.primary;
          animation = 'active';
        });
      } else {
        setState(() {
          color = resources.colors.primary.withOpacity(0.48);
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
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                Expanded(
                  flex: 6,
                  child: Container(
                    height: widget.height,

                    child: DropdownButton<String>(
                      hint: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 12),
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: icon(widget.icon)
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: Text(trim(widget.value, 6),
                              style: TextStyle(
                                color: resources.colors.primary,
                                fontSize: 16
                              ),
                            )
                          )
                        ]
                      ),
                      underline: Container(),
                      icon: Icon(                // Add this
                        Icons.arrow_drop_down,  // Add this
                        color: resources.colors.primary,   // Add this
                      ),
                      items: widget.items.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            width: 112,
                            child: Text(trim(value, 16),
                              style: TextStyle(
                                color: resources.colors.primary,
                              )
                            )
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          widget.value = value;
                        });
                      },
                    ),
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
  String trim(String string, int length) {
    return (string.length > length)
        ?
        string.substring(0, length) + '...'
        :
        string;
  }
}
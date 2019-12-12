import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BrInput extends StatefulWidget {
  _BrInputState state;

  String icon, placeholder, value;

  double height;
  bool obscure, autofocus;

  TextInputType type;
  TextInputAction action;

  void Function(BrInput, String) submit, change;

  BrInput({Key key,
    this.icon,
    this.placeholder = '',
    this.height = 60,
    this.obscure = false,
    this.type = TextInputType.text,
    this.action = TextInputAction.done,
    this.value,
    this.submit,
    this.change,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _BrInputState createState() {
    state = new _BrInputState();
    return state;
  }

  void settext(String text) {
    state.text(text);
  }
}

class _BrInputState extends State<BrInput> {
  String animation = 'idle';
  Color color = resources.colors.primary.withOpacity(0.48);
  FocusNode focus = new FocusNode();
  TextEditingController controller;

  @override
  void initState() {

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
    controller = new TextEditingController(text: widget.value);
    if(widget.autofocus)
      controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);

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
                  flex: (widget.type == TextInputType.visiblePassword) ? 7 : 9,
                  child: Container(
                    height: widget.height,
                    margin: EdgeInsets.only(left: 12),

                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hasFloatingPlaceholder: true,
                        alignLabelWithHint: true,
                        labelText: widget.placeholder,
                        contentPadding: EdgeInsets.only(bottom: 0),
                        labelStyle: TextStyle(
                          color: color,
                          letterSpacing: 0,
                        )
                      ),
                      cursorWidth: 1.5,
                      textInputAction: widget.action,
                      keyboardType: widget.type,
                      autofocus: widget.autofocus,
                      focusNode: focus,
                      style: TextStyle(
                        letterSpacing: (widget.type == TextInputType.visiblePassword) ? 8 : 0,
                      ),
                      obscureText: widget.obscure,

                      onSubmitted: (String value) {
                        widget.submit(widget, value);
                      },
                      onChanged: (String value) {
                        widget.value = value;
                        widget.change(widget, value);
                      },
                    ),
                  ),
                ),

                (widget.type == TextInputType.visiblePassword) ?
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 6),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 44,
                        height: 44,


                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: MaterialButton(
                            padding: EdgeInsets.all(9),
                            splashColor: resources.colors.light.withOpacity(0.24),
                            highlightColor: resources.colors.light.withOpacity(0.08),
                            onPressed: () {
                              setState(() {
                                widget.obscure = !widget.obscure;
                              });
                            },
                            child: Container(height: 32, width: 32, child: anchor('lib/interface/assets/flares/password_icon.flr')),
                          ),
                        ),
                      ),
                    ),
                  )
                )
                    :
                Container(),
              ],
            ),
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
    if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'svg' ) {
      return Container(margin: EdgeInsets.only(left: 10), height: 28, width: 28, child: SvgPicture.asset(icon, color: color));
    } else if (icon.substring(icon.lastIndexOf('.') + 1, icon.length) == 'flr') {
      return Container(height: 28, width: 28, child: FlareActor(icon, animation: animation, color: color,));
    }
  }
  Widget anchor(String icon) {
    if(icon != null) {
      return FlareActor(icon, animation: (widget.obscure) ? 'idle' :'active', color: color,);
    } else {
      return Container();
    }
  }
  void text(String text) {
    setState(() {
      controller = new TextEditingController(text: text);
    });
  }
}
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrSelectTaskGoal extends StatefulWidget {
  bool Function(BrSelectTaskGoal, bool) callback;

  BrSelectTaskGoal({Key key,
    @required this.callback
  }) : super(key: key,);

  @override
  _BrSelectTaskGoalState createState() => _BrSelectTaskGoalState();
}

class _BrSelectTaskGoalState extends State<BrSelectTaskGoal> {
  bool side = false;

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 144,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),

          child: Container(
            color: Colors.white,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  direction: Axis.horizontal,

                  children: <Widget>[
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              widget.callback(widget, false);
                            },
                            splashColor: resources.colors.light.withOpacity(0.16),
                            highlightColor: resources.colors.light.withOpacity(0.48),

                            borderRadius: BorderRadius.circular(4),
                            child: Opacity(
                              opacity: 0.64,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                          'NEW TASK',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: resources.colors.primary,
                                          )
                                      )
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 24, bottom: 16),

                                        height: 40,
                                        child: SvgPicture.asset('lib/interface/assets/icons/list.svg', color: resources.colors.primary,)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              widget.callback(widget, true);
                            },
                            splashColor: resources.colors.light.withOpacity(0.16),
                            highlightColor: resources.colors.light.withOpacity(0.48),
                            borderRadius: BorderRadius.circular(4),
                            child: Opacity(
                              opacity: 0.64,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                          'NEW GOAL',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: resources.colors.primary,
                                          )
                                      )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 24, bottom: 16),
                                        height: 40,
                                        child: SvgPicture.asset('lib/interface/assets/icons/mission.svg', color: resources.colors.primary,)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
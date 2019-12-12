import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class BrTabNavigation extends StatefulWidget {
  List<String> tabs;
  int selected = 0;

  BrTabNavigation({Key key,
    @required this.tabs

  }) : super(key: key);

  @override
  _BrTabNavigationState createState() => _BrTabNavigationState();
}

class _BrTabNavigationState extends State<BrTabNavigation> {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36,

      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,

            children: <Widget>[
              Expanded(
                flex: 2,
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 0;
                      });
                    },
                    splashColor: resources.colors.primary.withOpacity(0.08),
                    highlightColor: resources.colors.primary.withOpacity(0.24),
                    child: Container(
                      alignment: Alignment.center,
                      height: 32,
                      child: Text(
                        widget.tabs[0],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 1;
                      });
                    },
                    splashColor: resources.colors.primary.withOpacity(0.08),
                    highlightColor: resources.colors.primary.withOpacity(0.24),
                    child: Container(
                      alignment: Alignment.center,
                      height: 32,
                      child: Text(
                        widget.tabs[1],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 2;
                      });
                    },
                    splashColor: resources.colors.primary.withOpacity(0.08),
                    highlightColor: resources.colors.primary.withOpacity(0.24),
                    child: Container(
                      alignment: Alignment.center,
                      height: 32,
                      child: Text(
                        widget.tabs[2],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 4,
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: Duration(milliseconds: 400),
                  left: position(context, widget.selected),
                  curve: Curves.easeOutCubic,

                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,

                    height: 4,
                    width: width(context, widget.selected),

                    decoration: BoxDecoration(
                      color: resources.colors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            )
          )
        ],
      )
    );
  }
  
  double width(BuildContext context, int index) {
    int flex = 7;
    switch(index){
      case 0:
        flex = 2;
        break;
      case 1:
        flex = 2;
        break;
      case 2:
        flex = 3;
        break;
    }

    return MediaQuery.of(context).size.width * flex / 7.0;
  }
  double position(BuildContext context, int index) {
    int flex = 7;
    switch(index){
      case 0:
        flex = 7;
        break;
      case 1:
        flex = 5;
        break;
      case 2:
        flex = 3;
        break;
    }

    return MediaQuery.of(context).size.width * (7 - flex) / 7.0;
  }
}
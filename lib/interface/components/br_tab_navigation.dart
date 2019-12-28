import 'package:beautyreformatory/interface/screens/house/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class BrTabNavigation extends StatefulWidget {
  List<String> tabs;
  int selected;
  double width, height;

  void Function(BrTabNavigation, int) ontab;
  Stream stream;

  BrTabNavigation({Key key,
    @required this.tabs,
    @required this.ontab,
    @required this.stream,
    @required this.selected,
    this.width,
    this.height = 36,
  }) : super(key: key);

  @override
  _BrTabNavigationState createState() => _BrTabNavigationState();
}

class _BrTabNavigationState extends State<BrTabNavigation> {

  @override
  void initState() {
    widget.stream.listen((value) {
      if(mounted) {
        setState(() {
          widget.selected = value as int;
        });
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,

      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,

            children: <Widget>[
              Expanded(
                flex: 2,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 0;
                        widget.ontab(widget, 0);
                      });
                    },
                    splashColor: resources.colors.primary.withOpacity(0.08),
                    highlightColor: resources.colors.primary.withOpacity(0.24),
                    child: Container(
                      alignment: Alignment.center,
                      height: widget.height - 4,
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
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 1;
                        widget.ontab(widget, 1);
                      });
                    },
                    splashColor: resources.colors.primary.withOpacity(0.08),
                    highlightColor: resources.colors.primary.withOpacity(0.24),
                    child: Container(
                      alignment: Alignment.center,
                      height: widget.height - 4,
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
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 2;
                        widget.ontab(widget, 2);
                      });
                    },
                    splashColor: resources.colors.primary.withOpacity(0.08),
                    highlightColor: resources.colors.primary.withOpacity(0.24),
                    child: Container(
                      alignment: Alignment.center,
                      height: widget.height - 4,
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

    return ((widget.width == null) ? MediaQuery.of(context).size.width : widget.width) * flex / 7.0;
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

    return ((widget.width == null) ? MediaQuery.of(context).size.width : widget.width) * (7 - flex) / 7.0;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class BrTabNavigation extends StatefulWidget {
  List<String> tabs;
  int selected;
  double width, height;
  Color theme;
  List<int> flex;

  void Function(BrTabNavigation, int) ontab;
  Stream stream;

  BrTabNavigation({Key key,
    @required this.tabs,
    @required this.ontab,
    @required this.stream,
    @required this.selected,
    this.flex = const [2, 2, 3],
    this.theme,
    this.width,
    this.height = 36,
  }) {
    if(this.theme == null)
      this.theme = resources.colors.primary;
  }

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
                flex: widget.flex[0],
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 0;
                        widget.ontab(widget, 0);
                      });
                    },
                    splashColor: widget.theme.withOpacity(0.08),
                    highlightColor: widget.theme.withOpacity(0.24),
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
                flex: widget.flex[1],
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 1;
                        widget.ontab(widget, 1);
                      });
                    },
                    splashColor: widget.theme.withOpacity(0.08),
                    highlightColor: widget.theme.withOpacity(0.24),
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
                flex: widget.flex[2],
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.selected = 2;
                        widget.ontab(widget, 2);
                      });
                    },
                    splashColor: widget.theme.withOpacity(0.08),
                    highlightColor: widget.theme.withOpacity(0.24),
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
                      color: widget.theme,
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
    int flex = widget.flex[index];

    return ((widget.width == null) ? MediaQuery.of(context).size.width : widget.width) * flex / widget.flex.reduce((a, b) => a + b);
  }
  double position(BuildContext context, int index) {
    int flex = widget.flex.reduce((a, b) => a + b);
    switch(index){
      case 0:
        flex = flex;
        break;
      case 1:
        flex = widget.flex.reduce((a, b) => a + b) - widget.flex[0];
        break;
      case 2:
        flex = widget.flex.reduce((a, b) => a + b) - widget.flex[0] - widget.flex[1];
        break;
    }

    return ((widget.width == null) ? MediaQuery.of(context).size.width : widget.width) * (widget.flex.reduce((a, b) => a + b) - flex) / widget.flex.reduce((a, b) => a + b);
  }
}
import 'package:beautyreformatory/interface/components/br_tab_navigation.dart';
import 'package:beautyreformatory/interface/screens/house/elements/search_lightroom.dart';
import 'package:beautyreformatory/interface/screens/house/lightroom/lightroom.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';

class LightroomTopNavigation extends StatefulWidget {

  User user;
  int tab;
  void Function(LightroomTopNavigation, int) ontab;

  LightroomTopNavigation({Key key,
    @required this.ontab,
    @required this.user,
    this.tab = 0,
  }) : super(key: key);

  @override
  _LightroomTopNavigationState createState() => _LightroomTopNavigationState();
}

class _LightroomTopNavigationState extends State<LightroomTopNavigation> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 4.0, spreadRadius: 4.0
            )
          ]
        ),
        child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),

                    child: Text(
                      'LightRoom',
                      style: TextStyle(
                          color: Colors.black87.withOpacity(0.64),
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    )
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 48,
                    child: SearchLightroom()
                ),
                Container(
                    margin: EdgeInsets.only(top: 24),

                    child: BrTabNavigation(
                      tabs: ['Mental Health', 'Body Health', 'Spirituality'],
                      flex: [2, 2, 2],
                      stream: Lightroom.page_controller.stream,
                      ontab: (view, index) => widget.ontab(widget, index),
                      selected: widget.tab,
                      theme: resources.colors.secondary,
                    )
                )
              ],
            ),
      ),
    );
  }
}
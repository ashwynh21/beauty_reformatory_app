import 'dart:async';

import 'package:beautyreformatory/interface/screens/house/elements/friends.dart';
import 'package:beautyreformatory/interface/screens/house/elements/message_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messaging extends StatelessWidget {
  /*
  We have added this stream controller to make the system widget dynamic to
  the users click event on the search button. When the user clicks on the search
  button the stream will add the switching callback variable to the stream in
  which the handling component of this interface will the be listening in for
  a change event.
   */
  static StreamController search_controller = new StreamController<bool>.broadcast();
  static StreamController page_controller = new StreamController<int>.broadcast();

  /*
  The tabbing system of the profile I have created to operate from here where
  this profile class will be the entity that controls the navigation around the
  smaller elements of the rest of the user interface.
   */
  PageController tab_controller = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      child: Stack(
        children: <Widget>[

          /*
          Here will be the interface holding the contents of the tabs, though
          what displays here will be controlled by the tabs.

          To handle the search functionality of this interface we would like
          to add the hero effect to transition to the search user interface.

          with that we will create a building function that will handle the
          switching process for when the user clicks on the search button in the
          tabs widget above.

          Each tab will control the sub screen below it, that the inbox, friends
          and influencers tab.
           */

          PageView.builder(
            itemCount: 3,
            controller: tab_controller,
            onPageChanged: (index) {
              page_controller.sink.add(index);
            },
            itemBuilder: (BuildContext context, index) {
              switch(index) {
                case 0:
                  return Container();
                case 1:
                  return Friends(
                    reload: (view) {

                    }
                  );
                case 2:
                  return Container();
                default:
                  return Container();
              }

            },
          ),

          MessageTabs(
            ontab: (view, index) {
              tab_controller.animateToPage(index, duration: Duration(milliseconds: 480), curve: Curves.easeOutCubic);
            },
          ),
        ],
      )
    );
  }

}

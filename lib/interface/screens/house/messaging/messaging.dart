import 'dart:async';

import 'package:beautyreformatory/interface/screens/house/elements/friends.dart';
import 'package:beautyreformatory/interface/screens/house/elements/inbox.dart';
import 'package:beautyreformatory/interface/screens/house/elements/influencers.dart';
import 'package:beautyreformatory/interface/screens/house/elements/message_tabs.dart';
import 'package:beautyreformatory/interface/screens/house/elements/status_bar.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messaging extends StatefulWidget {
  /*
  We have added this stream controller to make the system widget dynamic to
  the users click event on the search button. When the user clicks on the search
  button the stream will add the switching callback variable to the stream in
  which the handling component of this interface will the be listening in for
  a change event.
   */
  static StreamController page_controller = new StreamController<int>.broadcast();


  @override
  State<StatefulWidget> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  /*
  The tabbing system of the profile I have created to operate from here where
  this profile class will be the entity that controls the navigation around the
  smaller elements of the rest of the user interface.
   */
  int current_tab;
  PageController tab_controller;

  @override
  void initState() {
    current_tab = 0;
    tab_controller = new PageController(initialPage: 0);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          color: Colors.white,

          child: Stack(
            alignment: Alignment.topCenter,
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

              Container(
                margin: EdgeInsets.only(top: 80),
                child: PageView.builder(
                  itemCount: 3,
                  controller: tab_controller,
                  onPageChanged: (index) {
                    Messaging.page_controller.sink.add(index);
                    current_tab = index;
                  },
                  itemBuilder: (BuildContext context, index) {
                    switch(index) {
                      case 0:
                        return Inbox();
                      case 1:
                        return Friends();
                      case 2:
                        return Influencers();
                      default:
                        return Container();
                    }

                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 80),
                child: MessageTabs(
                  ontab: (view, index) {
                    tab_controller.animateToPage(index, duration: Duration(milliseconds: 480), curve: Curves.easeOutCubic);
                    current_tab = index;
                  },
                  tab: current_tab,
                ),
              ),

              StatusBar(),
              dialogs.loader,
              dialogs.snack,
            ],
          )
      ),
    );
  }
}
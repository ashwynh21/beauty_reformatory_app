import 'dart:async';

import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/interface/screens/house/elements/profile_top_navigation.dart';
import 'package:beautyreformatory/interface/screens/house/elements/status_profile_edit.dart';
import 'package:beautyreformatory/interface/screens/house/elements/task_manager.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Profile extends StatelessWidget {
  /*
  Since the constructor of the user controller initializes a user into the
  user controller stream we can then just construct a controller here so that
  the bound widgets can build.

  I am considering using an integer stream to control the tabbing system
  because the rebuilding of the user interface is becoming glitchy and
  a stream would allow me to compartmentalize which parts of the interface
  rebuild.
   */
  static StreamController page_controller = new StreamController<int>.broadcast();

  /*
  The tabbing system of the profile I have created to operate from here where
  this profile class will be the entity that controls the navigation around the
  smaller elements of the rest of the user interface.
   */
  PageController tab_controller = new PageController();

  Profile({Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              PageView.builder(
                itemCount: 3,
                controller: tab_controller,
                onPageChanged: (index) {
                  page_controller.sink.add(index);
                },
                itemBuilder: (BuildContext context, index) {
                  switch(index) {
                    case 0:
                      return StatusProfileEdit();
                    case 1:
                      return Container();
                    case 2:
                      return TaskManager();
                    default:
                      return Container();
                  }

                },
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: FutureBuilder(
                    future: UserMiddleware.fromSave(),
                    builder: (context, user) {
                      if(user.hasData) {
                        return ProfileTopNavigation(
                          user: user.data,
                          tab: tab_controller.page.round(),
                          ontab: (view, index) {
                            tab_controller.animateToPage(index, duration: Duration(milliseconds: 480), curve: Curves.easeOutCubic);
                          },
                        );
                      }

                      return Container();
                    }
                  )
              ),

              dialogs.loader,
              dialogs.snack,
            ],
          ),
        ),
      ),
    );
  }
}
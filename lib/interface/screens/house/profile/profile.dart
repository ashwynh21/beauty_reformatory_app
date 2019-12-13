import 'dart:async';

import 'package:beautyreformatory/interface/screens/house/elements/emotions_rating.dart';
import 'package:beautyreformatory/interface/screens/house/elements/profile_top_navigation.dart';
import 'package:beautyreformatory/interface/screens/house/elements/status_update.dart';
import 'package:beautyreformatory/services/middleware/emotion_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/emotion.dart';
import 'package:flutter/material.dart';

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

      child: Stack(
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
                  return Container(

                    margin: EdgeInsets.only(top: 320),
                    child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            FutureBuilder(
                              future: UserMiddleware.fromSave(),
                              builder: (context, user) {
                                if(user.hasData){
                                  return StatusUpdate(
                                    user: user.data,
                                  );
                                }

                                return Container();
                              }
                            ),

                            FutureBuilder(
                                future: EmotionMiddleware.listFromSave().then((List<Emotion> emotions) => emotions[0]),
                                builder: (context, emotion) {
                                  if(emotion.hasData) {
                                    return EmotionsRating(
                                      emotion: emotion.data,
                                    );
                                  }

                                  return Container();
                                }
                            )
                          ],
                        )
                    ),
                  );
                case 1:
                  return Container();
                case 2:
                  return Container();
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
                      ontab: (view, index) {
                        tab_controller.animateToPage(index, duration: Duration(milliseconds: 480), curve: Curves.easeOutCubic);
                      },
                    );
                  }

                  return Container();
                }
              )
          ),
        ],
      ),
    );
  }
}
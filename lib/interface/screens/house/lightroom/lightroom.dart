import 'dart:async';

import 'package:beautyreformatory/interface/screens/house/elements/lightroom_top_navigation.dart';
import 'package:beautyreformatory/interface/screens/house/elements/mental_health.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:flutter/material.dart';

class Lightroom extends StatelessWidget {
  static StreamController page_controller = new StreamController<int>.broadcast();

  PageController tab_controller = new PageController();

  Lightroom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Material(
            color: Colors.white,

            child: Column(
              children: <Widget>[
                FutureBuilder(
                    future: UserMiddleware.fromSave(),
                    builder: (context, user) {
                      if(user.hasData) {
                        return LightroomTopNavigation(
                          user: user.data,
                          ontab: (view, index) {
                            tab_controller.animateToPage(index, duration: Duration(milliseconds: 480), curve: Curves.easeOutCubic);
                          },
                        );
                      }

                      return Container();
                    }
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 296,
                    child:
                    PageView.builder(
                      itemCount: 3,
                      controller: tab_controller,
                      onPageChanged: (index) {
                        page_controller.sink.add(index);
                      },
                      itemBuilder: (BuildContext context, index) {
                        switch(index) {
                          case 0:
                            return MentalHealth();
                          default:
                            return Container();
                        }
                      },
                    )
                )
              ],
            )
        )
    );
  }
}

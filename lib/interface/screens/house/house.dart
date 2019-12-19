import 'package:beautyreformatory/interface/screens/house/elements/navigation_bar.dart';
import 'package:beautyreformatory/interface/screens/house/messaging/messaging.dart';
import 'package:beautyreformatory/interface/screens/house/profile/profile.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:flutter/material.dart';

import 'elements/status_bar.dart';

class House extends StatelessWidget {

  House({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          color: Colors.white,

          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[

              /*
                  Content will be managed in this containment below.
                   */
              Container(
                margin: EdgeInsets.only(top: 80),

                child: PageView.builder(
                  controller: PageController(initialPage: 1),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    switch(index) {
                      case 0:
                        return Profile();
                      case 1:
                        return Messaging();
                      default:
                        return Container();
                    }
                  }
                ),
              ),

              StatusBar(),

              NavigationBar(),

              snack,
              loader,

            ],
          )
      ),
    );
  }
}
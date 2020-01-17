import 'package:beautyreformatory/interface/screens/house/elements/navigation_bar.dart';
import 'package:beautyreformatory/interface/screens/house/lightroom/lightroom.dart';
import 'package:beautyreformatory/interface/screens/house/profile/profile.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:flutter/material.dart';

import 'elements/status_bar.dart';

class House extends StatelessWidget {
  PageController controller = new PageController(initialPage: 3);

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
                  controller: controller,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    switch(index) {
                      case 0:
                        return Container();
                      case 1:
                        return Container();
                      case 2:
                        return Lightroom();
                      case 3:
                        return Profile();
                      default:
                        return Container();
                    }
                  }
                ),
              ),

              StatusBar(),

              NavigationBar(
                click: (int index) {
                  controller.animateToPage(index, duration: Duration(milliseconds: 320), curve: Curves.easeOutCubic);

                  return false;
                }
              ),

              dialogs.snack,
              dialogs.loader,

            ],
          )
      ),
    );
  }
}
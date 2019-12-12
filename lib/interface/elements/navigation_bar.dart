import 'dart:convert';

import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  BrIcon circles, settings, lightroom, profile;

  User user;

  @override
  void initState() {
    _inputinit();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        elevation: 0,
        color: Colors.transparent,

        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 96,
            decoration: BoxDecoration(

              gradient: LinearGradient(

                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                stops: [0, 0.64],
                colors: [
                  Colors.white.withOpacity(0),
                  Colors.white,
                ],
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          child: circles
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12),
                          child: settings
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(32),
                  child: SvgPicture.asset('lib/interface/assets/icons/main.svg', height: 64)
                ),
                Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 12),
                          child: lightroom
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                          child: StreamBuilder(
                            stream: UserController.stream.stream,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return BrAvatar(
                                  src: snapshot.data.image,
                                  elevation: 4,
                                  size: 40,
                                  radius: 20,
                                );
                              }

                              return Container();
                            },
                          )
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  void _inputinit() {
    circles = BrIcon(
        src: 'lib/interface/assets/icons/circles.svg',
        color: resources.colors.primary,
        size: 48,
        click: (view) {

        }
    );
    settings = BrIcon(
        src: 'lib/interface/assets/icons/settings.svg',
        color: resources.colors.primary,
        size: 48,
        click: (view) {

        }
    );
    lightroom = BrIcon(
        src: 'lib/interface/assets/icons/lightroom.svg',
        color: resources.colors.primary,
        size: 48,
        click: (view) {

        }
    );
  }
}
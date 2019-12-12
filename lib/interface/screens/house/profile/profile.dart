import 'package:beautyreformatory/interface/elements/emotions_rating.dart';
import 'package:beautyreformatory/interface/elements/profile_top_navigation.dart';
import 'package:beautyreformatory/interface/elements/status_update.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    /*
    Since the constructor of the user controller initializes a user into the
    user controller stream we can then just construct a controller here so that
    the bound widgets can build.
     */
    UserController();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 320),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    StatusUpdate(),

                    EmotionsRating()
                  ],
                )
            ),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 24),
              child: ProfileTopNavigation()
          ),
        ],
      ),
    );
  }
}
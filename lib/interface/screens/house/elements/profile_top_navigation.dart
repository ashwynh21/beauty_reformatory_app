import 'package:beautyreformatory/interface/components/br_tab_navigation.dart';
import 'package:beautyreformatory/interface/screens/house/elements/handle_editor.dart';
import 'package:beautyreformatory/interface/screens/house/profile/profile.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'avatar_editor.dart';
import 'friends_display.dart';
import 'fullname_editor.dart';

class ProfileTopNavigation extends StatelessWidget {
  User user;
  int tab;
  void Function(ProfileTopNavigation, int) ontab;

  ProfileTopNavigation({Key key,
    @required this.ontab,
    @required this.user,
    this.tab = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black12,

      child: Container(
        height: 320,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,

          children: <Widget>[
            Image.asset('lib/interface/assets/images/background.png',),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                /*
                User's avatar is here
                 */
                Container(
                  margin: EdgeInsets.only(top: 24, bottom: 12),

                  child: AvatarEditor(user: user),
                ),

                /*
                User's full name is here
                 */
                FullnameEditor(user: user),

                /*
                User's handle is here
                 */
                HandleEditor(user: user),

                /*
                User's friends is gotten and displayed here
                 */
                FriendsDisplay(user: user),

                /*
                The profile navigation tabs will go here
                 */
                Container(
                    margin: EdgeInsets.only(top: 8),

                    child: BrTabNavigation(
                      tabs: ['profile info.', 'posts & content', 'goals & affirmations'],
                      stream: Profile.page_controller.stream,
                      ontab: (view, index) => ontab(this, index),
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

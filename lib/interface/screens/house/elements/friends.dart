import 'dart:async';

import 'package:beautyreformatory/interface/screens/house/elements/user_list_item.dart';
import 'package:beautyreformatory/services/middleware/friendship_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Friends extends StatefulWidget {
  static StreamController friends_controller = new BehaviorSubject<List<Friendship>>();

  @override
  State<StatefulWidget> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  User user;

  @override
  void initState() {
    _initfriends();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
                child: StreamBuilder<List<Friendship>>(
                    stream: Friends.friends_controller.stream.asBroadcastStream(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData && (snapshot.data..removeWhere((e) => (e.state != accepted))).length > 0) {
                        return Container(
                          margin: EdgeInsets.only(top: 56),
                          child: Column(
                            children: (snapshot.data..removeWhere((e) => (e.state != accepted))).map((m) {
                              User friend = (m.initiator.id == user.id) ? m.subject : m.initiator;

                              return UserListItem(
                                  state: m.state,
                                  user: friend,
                                  callback: (view) {
                                    _initfriends();
                                  },
                              );
                            }).toList(),
                          ),
                        );
                      }

                      /*
                      Since this is the default view of the inbox here we have the opportunity
                      to guide and encourage the user to populate data onto this part of the
                      application or specifically start conversations with other users.
                       */
                      return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 160),
                                  child: Opacity(
                                      opacity: 0.64,
                                      child: Image.asset('lib/interface/assets/images/love.png')
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 80),
                                  child: Text(
                                    'Add your friends and family by sending the people you love friend requests.',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: resources.colors.primary.withOpacity(0.64),
                                        height: 1.4
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                              )
                            ],
                          )
                      );
                    }
                )
            ),

            dialogs.loader,
            dialogs.snack,
          ],
        ),
      ),
    );
  }

  void _initfriends() {
    UserMiddleware.fromSave().then((User u) {
      user = u;

      FriendshipMiddleware.listFromSave().then((List<Friendship> list) {
        Friends.friends_controller.sink.add(list);
      });
    });
  }
}
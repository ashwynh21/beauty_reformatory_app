import 'dart:async';

import 'package:beautyreformatory/services/middleware/friendship_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';

import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';

import 'package:rxdart/rxdart.dart';

class Influencers extends StatefulWidget {
  static StreamController influencers_controller = new BehaviorSubject<List<Friendship>>();

  Influencers({Key key}) : super(key: key);

  @override
  _InfluencersState createState() => _InfluencersState();
}

class _InfluencersState extends State<Influencers> {
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
                    stream: Influencers.influencers_controller.stream.asBroadcastStream(),
                    builder: (context, snapshot) {

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
                                  margin: EdgeInsets.symmetric(horizontal: 144),
                                  child: Opacity(
                                      opacity: 0.32,
                                      child: Image.asset('lib/interface/assets/images/influencer.png')
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 80),
                                  child: Text(
                                    'Find your favorite content influencers and have conversations about great products that can change and improve your lifestyle.',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: resources.colors.primary.withOpacity(0.64),
                                        height: 1.4
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                              ),
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
        Influencers.influencers_controller.sink.add(list);
      });
    });
  }
}
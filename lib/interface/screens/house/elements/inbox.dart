import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/interface/screens/house/elements/user_list_item.dart';
import 'package:beautyreformatory/services/controllers/message_controller.dart';
import 'package:beautyreformatory/services/middleware/friendship_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/message.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'chat.dart';

class Inbox extends StatefulWidget {
  static StreamController friends_controller = new BehaviorSubject<List<Friendship>>();

  Inbox({Key key}) : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  User user;

  FirebaseMessaging _firebase;

  @override
  void initState() {
    _initfriends();
    _initfirebase(context).then((f) {
      _firebase = f;
    });

    super.initState();
  }
  @override
  void didUpdateWidget(Inbox oldWidget) {
    _initfirebase(context).then((f) {
      _firebase = f;
    });
    super.didUpdateWidget(oldWidget);
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
                    stream: Inbox.friends_controller.stream.asBroadcastStream(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData && (snapshot.data..removeWhere((e) => (
                          e.state == blocked || e.state == declined || e.state == cancelled
                      ))).length > 0) {
                        return Container(
                          margin: EdgeInsets.only(top: 56),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, index) {
                              Friendship m = snapshot.data[index];

                              User friend = (m.initiator.id == user.id) ? m.subject : m.initiator;
                              return UserListItem(
                                  state: (m.initiator.id != user.id && m.state == pending) ? unapproved : m.state,
                                  user: friend,
                                  lastchat: true,
                                  callback: (view) {
                                    _initfriends();
                                  },
                                  click: (m.state == accepted || (m.state == pending && m.initiator.email == user.email)) ? (view) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => Chat(
                                              user: friend,
                                              state: (m.initiator.id != user.id && m.state == pending) ? unapproved : m.state
                                          ),
                                        ),
                                      );

                                  } : null
                              );

                            },
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
                              margin: EdgeInsets.symmetric(horizontal: 144),
                              child: Opacity(
                                opacity: 0.32,
                                child: Image.asset('lib/interface/assets/images/chat.png')
                              )
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 80),
                              child: Text(
                                'Start conversations and share content with the people you love right here.',
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
        Inbox.friends_controller.sink.add(list..removeWhere((e) => (e.state == blocked || e.state == declined || e.state == cancelled)));
      });
    });
  }
  /*
  Here we are trying to establish a connection to firebase in order to refresh
  the user interface each time the user has a notification for a new message
   */
  Future<FirebaseMessaging> _initfirebase(BuildContext context) async {
    return (new FirebaseMessaging())..configure(
      onMessage: (Map<String, dynamic> message) async {
        String instruction = message['data']['instruction'];
        if(instruction == 'message_delivery'){
          UserMiddleware.fromSave().then((User user){

            MessageController().paged(email: user.email, token: user.token, friend: jsonDecode(message['data']['sender'])['email'])
                .then((List<Message> messages) {

            });
          });
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        String instruction = message['data']['instruction'];
        if(instruction == 'message_delivery'){
          UserMiddleware.fromSave().then((User user){

            MessageController().paged(email: user.email, token: user.token, friend: jsonDecode(message['data']['sender'])['email'])
                .then((List<Message> messages) {


            });
          });
        }
      },
    );
  }
}
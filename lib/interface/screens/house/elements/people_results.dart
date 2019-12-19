import 'dart:convert';

import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/services/controllers/abuse_controller.dart';
import 'package:beautyreformatory/services/controllers/friendship_controller.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class PeopleResults extends StatelessWidget {
  Stream<List<Map>> stream;
  void Function(PeopleResults) reload;

  PeopleResults({Key key,
    @required this.stream,
    @required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return
      StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData)
            return Container(
              width: double.infinity,

              child: Column(
                children: <Widget>[
                  Container(
                      height: 36,
                      color: resources.colors.primary.withOpacity(0.64),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Text('people',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  ),
                  Container(height: 1, width: double.infinity, color: Colors.white),
                  Container(
                    child: Column(
                      children: (snapshot.data as List<Map>).map((m) {
                        return Container(
                          child: InkWell(
                            onTap: () {
                              dialogs.userprofile(context,
                                image: m['image'],
                                id: m['id'],
                                fullname: m['fullname'],
                                email: m['email'],
                                state: int.parse(m['state']),
                                add: (view) {
                                  loader.show(true);
                                  return UserMiddleware.fromSave().then((User user) {
                                    return FriendshipController().add(email: user.email, token: user.token, subject: m['email']).then((Friendship friendship) {
                                      reload(this);
                                      /*
                                        From this step we can the proceed to making the reaction control system for the controller
                                        to be able to confirm that the user has been blocked in the processing system of the server.
                                         */
                                      snack.show('Hey, friend request has been sent!');

                                      loader.show(false);
                                    }).catchError((error) {
                                      snack.show(error.message);
                                      loader.show(false);
                                    });
                                  });
                                },
                                report: (view, value) {
                                  loader.show(true);
                                  return UserMiddleware.fromSave().then((User user) {
                                    return AbuseController().report(email: user.email,
                                        token: user.token,
                                        subject:  m['email'],
                                        description: value
                                    ).then((abuse) {
                                      if(abuse != null) {
                                        snack.show('Hey, your report has been submitted');

                                        return abuse;
                                      }

                                      return null;
                                    }).catchError((error) {
                                      snack.show(error.message);
                                      loader.show(false);
                                    }).whenComplete(() {
                                      loader.show(false);
                                    });
                                  });
                                },
                                callback: (view) {
                                  loader.show(true);
                                  if(view.state != blocked) {
                                    loader.show(true);
                                    UserMiddleware.fromSave().then((User user) {
                                      FriendshipController().block(email: user.email, token: user.token, subject: m['email']).then((friendship) {
                                        reload(this);
                                        /*
                                        From this step we can the proceed to making the reaction control system for the controller
                                        to be able to confirm that the user has been blocked in the processing system of the server.
                                         */
                                        loader.show(false);
                                      }).catchError((error) {
                                        snack.show(error.message);
                                        loader.show(false);
                                      });
                                    });
                                  } else {
                                    UserMiddleware.fromSave().then((User user) {
                                      FriendshipController().remove(email: user.email, token: user.token, subject: m['email']).then((friendship) {
                                        reload(this);
                                        /*
                                        From this step we can the proceed to making the reaction control system for the controller
                                        to be able to confirm that the user has been blocked in the processing system of the server.
                                         */
                                        loader.show(false);
                                      }).catchError((error) {
                                        snack.show(error.message);
                                        loader.show(false);
                                      });
                                    });
                                  }
                                }
                              );
                            },
                            splashColor: resources.colors.primary.withOpacity(0.24),
                            highlightColor: resources.colors.primary.withOpacity(0.08),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      child: BrAvatar(
                                        src: m['image'],
                                        frame: 2,
                                        elevation: 2,
                                        radius: 20,
                                        size: 40,
                                        hero: m['id'],
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        m['fullname'],
                                        style: TextStyle(
                                          color: (int.parse(m['state']) == accepted) ? resources.colors.primary : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                                (int.parse(m['state']) == blocked)
                                    ?
                                Container(
                                  margin: EdgeInsets.only(right: 24),
                                  child: BrIcon(
                                    src: 'lib/interface/assets/icons/block.svg',
                                    color: resources.colors.primary.withOpacity(0.24),
                                    click: (view) {
                                      /*
                                      This will allow the user to unblock a user that has previously
                                      been blocked by this user.
                                       */
                                      dialogs.confirmoperation(context, message: 'you are about to unblock ${m['fullname']}. proceed?', callback: (view, confirmed) async {
                                        if(confirmed) {

                                          loader.show(true);
                                          UserMiddleware.fromSave().then((User user) {
                                            FriendshipController().remove(email: user.email, token: user.token, subject: m['email']).then((friendship) {
                                              reload(this);
                                              /*
                                              From this step we can the proceed to making the reaction control system for the controller
                                              to be able to confirm that the user has been blocked in the processing system of the server.
                                               */
                                              loader.show(false);
                                            }).catchError((error) {
                                              loader.show(false);
                                            });
                                          });
                                        }
                                      });
                                    }
                                  )
                                )
                                    :
                                Container()
                              ],
                            ),
                          )
                        );
                      }).toList(),
                    )
                  )
                ],
              ),
            );
          return Container();
        },
      );
  }
}

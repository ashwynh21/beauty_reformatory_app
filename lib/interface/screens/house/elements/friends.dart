import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/services/controllers/abuse_controller.dart';
import 'package:beautyreformatory/services/controllers/friendship_controller.dart';
import 'package:beautyreformatory/services/middleware/friendship_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';

class Friends extends StatelessWidget {
  void Function(Friends) reload;

  Friends({Key key,
    @required this.reload
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 56),
              child: FutureBuilder<User>(
                future: UserMiddleware.fromSave(),
                builder: (context, user) {
                  if(user.hasData)
                    return FutureBuilder<List<Friendship>>(
                    future: FriendshipMiddleware.listFromSave(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Column(
                          children: snapshot.data.map((m) {
                            User friend = (m.initiator.id == user.data.id) ? m.subject : m.initiator;

                            return Container(
                                child: InkWell(
                                  onTap: () {
                                    /*
                                    This event will open the chat window between the two users. Much
                                    consideration required on the provided design of the application.
                                     */
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
                                              src: friend.image,
                                              frame: 2,
                                              elevation: 2,
                                              radius: 20,
                                              size: 40,
                                              hero: friend.id,
                                              click: (view) {
                                                dialogs.userprofile(context,
                                                    image: friend.image,
                                                    id: friend.id,
                                                    fullname: friend.fullname,
                                                    email: friend.email,
                                                    state: m.state,
                                                    icon: 'lib/interface/assets/icons/chat.svg',
                                                    add: (view) {
                                                      /*
                                                      This function should do the same function as simply tapping
                                                      on the user item. It should open the chat window and
                                                      display the list of messages that follow with this friendship
                                                      between the two users.
                                                       */
                                                    },
                                                    report: (view, value) {
                                                      loader.show(true);
                                                      return UserMiddleware.fromSave().then((User user) {
                                                        return AbuseController().report(email: user.email,
                                                            token: user.token,
                                                            subject:  friend.email,
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
                                                          FriendshipController().block(email: user.email, token: user.token, subject: friend.email).then((friendship) {
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
                                                          FriendshipController().remove(email: user.email, token: user.token, subject: friend.email).then((friendship) {
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
                                            ),
                                          ),
                                          Container(
                                              child: Text(
                                                friend.fullname,
                                                style: TextStyle(
                                                    color: (m.state == accepted) ? resources.colors.primary : Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                      (m.state == blocked)
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
                                                dialogs.confirmoperation(context, message: 'you are about to unblock ${friend.fullname}. proceed?', callback: (view, confirmed) async {
                                                  if(confirmed) {

                                                    loader.show(true);
                                                    UserMiddleware.fromSave().then((User user) {
                                                      FriendshipController().remove(email: user.email, token: user.token, subject: friend.email).then((friendship) {
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
                        );
                      }

                      return Container();
                    }
                  );
                  return Container();
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}

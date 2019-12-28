import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/services/controllers/abuse_controller.dart';
import 'package:beautyreformatory/services/controllers/friendship_controller.dart';
import 'package:beautyreformatory/services/middleware/message_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/message.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat.dart';

class UserListItem extends StatefulWidget {
  int state;
  User user;
  bool lastchat;

  void Function(UserListItem) callback;
  void Function(UserListItem) click;

  UserListItem({Key key,
    @required this.state,
    this.user,
    this.callback,
    this.click,
    this.lastchat = false,
  }) : super(key: key);

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  int _counter = 0;

  @override
  void initState() {
    /*
    With this component and in the init state callback function we need to
    check if this user has sent any messages or if there are any unread messages
    from this user and mark them appropriately with a badge counting the
    number of messages that have not been read yet.
     */
    MessageMiddleware.listFriendFromSave(widget.user.email).then((List<Message> messages) {
      if(messages != null) {
        messages.forEach((message) {
          if(message.sender.email == widget.user.email && message.state != read) {
            /*
          Then this means that the client has not read the message and we should increment the counter
          for the build callback
           */
            _counter = _counter + 1;
          }
        });
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
          onTap: () {
            if(widget.click != null) {
              widget.click(widget);
            } else {
              showprofile();
            }
          },
          splashColor: resources.colors.primary.withOpacity(0.24),
          highlightColor: resources.colors.primary.withOpacity(0.08),

          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 18,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: BrAvatar(
                        src: widget.user.image,
                        frame: 2,
                        elevation: 2,
                        radius: 20,
                        size: 40,
                        hero: widget.user.id,
                        click: (view) {
                          showprofile();
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,

                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.user.fullname,
                                style: TextStyle(
                                    color: (
                                        widget.state == accepted ||
                                        widget.state == pending
                                    ) ? resources.colors.primary : Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FutureBuilder<String>(
                                    future: statetostring(widget.state),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData) {
                                        return Container(
                                          height: statetostring(widget.state) == null ? 0 : null,
                                          child: Text(
                                            snapshot.data ?? '',
                                            style: TextStyle(
                                                color: resources.colors.primary.withOpacity(0.32),
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    }
                                  ),
                                  FutureBuilder<String>(
                                    future: statetostring(widget.state, date: true),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData) {
                                        return Container(
                                          height: statetostring(widget.state, date: true) == null ? 0 : null,
                                          child: Text(
                                            snapshot.data ?? '',
                                            style: TextStyle(
                                                color: resources.colors.primary.withOpacity(0.32),
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    }
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                top: 8,
                child: displayendicon()
              )
            ],
          ),
        )
    );
  }

  Future sendrequestdialog() async{
    return await dialogs.confirmoperation(context,
        message: (widget.state != unapproved)
            ?
        'send friend request to ${widget.user.fullname}?'
            :
        'approve friend request from ${widget.user.fullname}?',
        callback: (view, confirmed) async {
          if(confirmed) {
            dialogs.loader.show(true);

            return UserMiddleware.fromSave().then((User user) {
              if(widget.state != unapproved) {
                return FriendshipController().add(email: user.email, token: user.token, subject: widget.user.email).then((Friendship friendship) {
                  setState(() {widget.state = pending;});
                  if(widget.callback != null) widget.callback(widget);
                  /*
                From this step we can the proceed to making the reaction control system for the controller
                to be able to confirm that the user has been blocked in the processing system of the server.
                 */
                  dialogs.snack.show('Hey, friend request has been sent!');

                  dialogs.loader.show(false);
                }).catchError((error) {
                  dialogs.snack.show(error.message);
                  dialogs.loader.show(false);
                });
              }

              return FriendshipController().approve(email: user.email, token: user.token, subject: widget.user.email).then((Friendship friendship) {
                setState(() {widget.state = pending;});
                if(widget.callback != null) widget.callback(widget);
                /*
                From this step we can the proceed to making the reaction control system for the controller
                to be able to confirm that the user has been blocked in the processing system of the server.
                 */
                dialogs.snack.show('Hey, friend request has been approved!');

                dialogs.loader.show(false);
              }).catchError((error) {
                dialogs.snack.show(error.message);
                dialogs.loader.show(false);
              });
            });
          }
    });
  }
  Future reportabuse(String value) async {

    dialogs.loader.show(true);
    return UserMiddleware.fromSave().then((User user) {
      return AbuseController().report(email: user.email,
          token: user.token,
          subject:  widget.user.email,
          description: value
      ).then((abuse) {
        if(abuse != null) {
          dialogs.snack.show('Hey, your report has been submitted');

          return abuse;
        }

        return null;
      }).catchError((error) {
        dialogs.snack.show(error.message);
        dialogs.loader.show(false);
      }).whenComplete(() {
        dialogs.loader.show(false);
      });
    });
  }
  Future blockorcancelrequest(int state) {
    Future Function() callback = () {
      dialogs.loader.show(true);
      if(state == pending) {
        return UserMiddleware.fromSave().then((User user) {
          return FriendshipController().cancel(email: user.email, token: user.token, subject: widget.user.email).then((friendship) {
            setState(() {widget.state = cancelled;});
            if(widget.callback != null) widget.callback(widget);
            /*
            From this step we can the proceed to making the reaction control system for the controller
            to be able to confirm that the user has been blocked in the processing system of the server.
             */
            dialogs.snack.show('Hey, request has been cancelled!');
            dialogs.loader.show(false);
          }).catchError((error) {
            dialogs.snack.show(error.message);
            dialogs.loader.show(false);
          });
        });
      } else if(state == unapproved) {
        return UserMiddleware.fromSave().then((User user) {
          return FriendshipController().approve(email: user.email, token: user.token, subject: widget.user.email,).then((friendship) {
            setState(() {widget.state = accepted;});
            if(widget.callback != null) widget.callback(widget);
            /*
            From this step we can the proceed to making the reaction control system for the controller
            to be able to confirm that the user has been blocked in the processing system of the server.
             */
            dialogs.loader.show(false);
          }).catchError((error) {
            dialogs.snack.show(error.message);
            dialogs.loader.show(false);
          });
        });
      } else if(state != blocked) {
        return UserMiddleware.fromSave().then((User user) {
          return FriendshipController().block(email: user.email, token: user.token, subject: widget.user.email).then((friendship) {
            setState(() {widget.state = blocked;});
            if(widget.callback != null) widget.callback(widget);
            /*
            From this step we can the proceed to making the reaction control system for the controller
            to be able to confirm that the user has been blocked in the processing system of the server.
             */
            dialogs.loader.show(false);
          }).catchError((error) {
            dialogs.snack.show(error.message);
            dialogs.loader.show(false);
          });
        });
      } else {
        return UserMiddleware.fromSave().then((User user) {
          return FriendshipController().remove(email: user.email, token: user.token, subject: widget.user.email).then((friendship) {
            setState(() {widget.state = removed;});
            if(widget.callback != null) widget.callback(widget);
            /*
            From this step we can the proceed to making the reaction control system for the controller
            to be able to confirm that the user has been blocked in the processing system of the server.
             */
            dialogs.loader.show(false);
          }).catchError((error) {
            dialogs.snack.show(error.message);
            dialogs.loader.show(false);
          });
        });
      }
    };

    if(state == pending) {
      return dialogs.confirmoperation(context, message: 'cancel request to ${widget.user.fullname}?', callback: (view, confirmed) async {
        if(confirmed) {
          return callback();
        }
      });
    } else if(state != blocked) {
      return dialogs.confirmoperation(context, message: 'block ${widget.user.fullname}? are you sure?', callback: (view, confirmed) async {
        if(confirmed) {
          return callback();
        }
      });
    } else if(state == unapproved) {
      return dialogs.confirmoperation(context, message: 'approve friend request from ${widget.user.fullname}?', callback: (view, confirmed) async {
        if(confirmed) {
          return callback();
        }
      });
    } else {
      return dialogs.confirmoperation(context, message: 'you are about to unblock ${widget.user.fullname}. proceed?', callback: (view, confirmed) async {
        if(confirmed) {
          return callback();
        }
      });
    }
  }
  Future showprofile() async {
    return UserMiddleware.fromSave().then((User u) {
      dialogs.userprofile(context,
        image: widget.user.image,
        id: widget.user.id,
        fullname: widget.user.fullname,
        email: widget.user.email,
        state: widget.state,

        left: (view) async {
          /*
          If the state of the relationship between the user and the result user
          is accepted, or pending then we must open the chat on click
           */
          if(widget.state == accepted || widget.state == pending) {
            return openchatwindow();
          }
          return sendrequestdialog();
        },
        report: (view, value) {
          return reportabuse(value);
        },
        right: (view) {
          return blockorcancelrequest(view.state);
        }
      );
    });
  }

  Future<String> statetostring(int state, {bool date = false}) async {
    List<Message> messages = (await MessageMiddleware.listFriendFromSave(widget.user.email));

    if(date) {
      switch(state) {
        case accepted:
          return (widget.lastchat)
              ?
          (messages.length > 0) ? timeago.format(DateTime.parse(messages[0].date['date'])) : null : null;
        case pending:
        case unapproved:
        case blocked:
        case declined:
        case cancelled:
        case removed:
        default:
          return null;

      }
    } else {
      switch(state) {
        case pending:
          return 'request sent';
        case unapproved:
          return 'friend request';
        case blocked:
          return 'blocked';
        case accepted:
          return (widget.lastchat)
              ?
          (date) ?
          (messages.length > 0) ? timeago.format(DateTime.parse(messages[0].date['date'])) : null
              :
          (messages.length > 0) ? (messages[0].message.length > 32 ? messages[0].message.substring(0, 32) + '...' : messages[0].message) : widget.user.status
              :
          widget.user.status;
        case declined:
        case cancelled:
        case removed:
        default:
          return null;

      }
    }
  }

  Widget displayendicon() {
    if(widget.state == blocked || widget.state == pending) {
      return
        Container(
            child: BrIcon(
                src: widget.state == blocked
                    ?
                'lib/interface/assets/icons/block.svg'
                    :
                'lib/interface/assets/icons/close.svg',

                color: resources.colors.primary.withOpacity(0.24),
                click: (view) {
                  /*
                          This will allow the user to unblock a user that has previously
                          been blocked by this user.
                           */
                  return blockorcancelrequest(widget.state);
                }
            )
        );
    } else if(widget.state == accepted) {
      return FutureBuilder<List<Message>>(
        future: MessageMiddleware.listFriendFromSave(widget.user.email),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            int value =  (snapshot.data..removeWhere((e) {
              return (e.state == read || e.sender.email != widget.user.email);
            })).length - 1;

            if(value > 0) {
              return Container(
                  margin: EdgeInsets.only(top: 6, right: 4),
                  height: 16,
                  width: 16,
                  child: Material(
                      borderRadius: BorderRadius.circular(6),
                      color: resources.colors.primary,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          value.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ),
                      )
                  )
              );
            }
          }
          return Container();
        }
      );
    } else {
      return Container();
    }
  }
  void openchatwindow() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, __, ___) => Chat(user: widget.user, state: widget.state),
        transitionDuration: Duration(milliseconds: 440),
      ),
    );
  }
}
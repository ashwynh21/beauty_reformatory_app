import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/interface/components/br_avatar_button.dart';
import 'package:beautyreformatory/interface/components/br_chat_input.dart';
import 'package:beautyreformatory/interface/components/br_chat_item.dart';
import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/services/controllers/message_controller.dart';
import 'package:beautyreformatory/services/middleware/message_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/message.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  User user;
  int state;

  Chat({Key key,
    @required this.user,
    @required this.state,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ChatState();
}

class _ChatState extends State<Chat> {

  List<Message> _messages;

  StreamController _stream;
  ScrollController _scroll;

  static FirebaseMessaging _firebase;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didUpdateWidget(Chat oldWidget) {
    MessageMiddleware.listFriendFromSave(widget.user.email).then((List<Message> messages) {
      _stream.sink.add(messages);
    });
    super.didUpdateWidget(oldWidget);
  }
  @override
  void initState() {
    _stream = new StreamController<List<Message>>.broadcast();
    _scroll = new ScrollController();
    MessageMiddleware.listFriendFromSave(widget.user.email).then((List<Message> messages) {
      _stream.sink.add(messages);
    });
    initfirebase(context).then((FirebaseMessaging messenger) {
      _ChatState._firebase = messenger;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Material(
            child: Stack(
              children: <Widget>[

                /*
                This is where the chat items are
                 */
                Container(
                  margin: EdgeInsets.only(top: 44),
                  constraints: BoxConstraints.expand(),
                  child: StreamBuilder<List<Message>>(
                      stream: _stream.stream,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          _messages = snapshot.data;

                          DateTime dateholder = DateTime.now();
                          int i = -1;
                          /*
                          Now we need to find the number of clusters of days and consider them
                          in the list given
                           */
                          int clusters = (snapshot.data.length == 1) ? 1 : 0;
                          snapshot.data.forEach((m) {
                            if(DateTime.parse(m.date['date']).day != dateholder.day)
                              clusters = clusters;

                            dateholder = DateTime.parse(m.date['date']);
                          });
                          dateholder = DateTime.now();

                          return Container(

                            child: ListView.builder(
                                controller: _scroll,
                                reverse: true,
                                itemCount: snapshot.data.length + clusters,
                                itemBuilder: (BuildContext context, int index) {
                                  /*
                                  The data read at this point needs to be groups by the days in which
                                  it was sent on and then marked with a date separator.
                                   */

                                  if((index == snapshot.data.length - 1 && index != 0) || (snapshot.data.length == 1 && index > 0)) {
                                    String day = DateTime.parse(snapshot.data[snapshot.data.length - 1].date['date']).day.toString() + '/' + DateTime.parse(snapshot.data[snapshot.data.length - 1].date['date']).month.toString();

                                    return Container(
                                        margin: EdgeInsets.only(bottom: 4, top: 20),
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Material(
                                            color: resources.colors.light.withOpacity(0.24),
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                                child: Text((snapshot.data.length == 1) ? datetostring(dateholder, DateTime.now()) : day,
                                                  style: TextStyle(
                                                      color: resources.colors.light
                                                  ),
                                                )
                                            )
                                        )
                                    );
                                  }

                                  i = i + 1;
                                  if(DateTime.parse(snapshot.data[i].date['date']).day == dateholder.day){
                                    dateholder = DateTime.parse(snapshot.data[i].date['date']);

                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: (index == 0) ? 64 : 0.0,
                                        top: (index == (snapshot.data.length - 1) && snapshot.data.length != 1) ? 12 : 0.0,
                                      ),
                                      child: BrChatItem(
                                        message: snapshot.data[i],
                                        origin: (widget.user.id != snapshot.data[i].sender.id),
                                      ),
                                    );
                                  } else {
                                    dateholder = DateTime.parse(snapshot.data[i].date['date']);

                                    return Container(
                                      margin: EdgeInsets.only(bottom: (index == 0) ? 72 : 8, top: 8),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Material(
                                        color: resources.colors.light.withOpacity(0.24),
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                            child: Text(datetostring(dateholder, DateTime.now()),
                                              style: TextStyle(
                                                color: resources.colors.light
                                              ),
                                            )
                                        )
                                      )
                                    );
                                  }
                                }
                            ),
                          );
                        }
                        return Container();
                      }
                  ),
                ),
                /*
                AppBar is over here.
                 */
                Material(
                  color: resources.colors.primary,
                  elevation: 8,
                  shadowColor: Colors.black26,
                  child: Container(
                    height: 52,
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: resources.colors.primary,
                      automaticallyImplyLeading: false,
                      title: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 16,
                            child: Container(
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    transform: Matrix4.identity()..translate(-8.0, 0.0, 0.0),
                                    child: BrAvatarButton(
                                      src: widget.user.image,
                                      click: (view) async {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      splashColor: Colors.white.withOpacity(0.12),
                                      highlightColor: Colors.white.withOpacity(0.24),
                                      onTap: () {},

                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              child: Text(widget.user.fullname,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              child: (widget.state == pending || widget.state == unapproved || widget.state == accepted && statustostring(widget.state) != null)
                                                  ?
                                              Text(statustostring(widget.state),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.normal
                                                ),
                                              )
                                                  :
                                              null,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: BrIcon(
                                      src: 'lib/interface/assets/icons/search.svg',
                                      color: Colors.white,

                                      click: (view) {}
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                /*
                Here we have the main chat input of the chat window
                 */
                BrChatInput(
                    user: widget.user,
                    tap: (view, value) {
                      _scroll.animateTo(0.0, duration: Duration(milliseconds: 320), curve: Curves.easeOutCubic);
                    },
                    change: (view, value) {
                      _scroll.animateTo(0.0, duration: Duration(milliseconds: 320), curve: Curves.easeOutCubic);
                    },
                    submit: (view, value) {
                      _scroll.animateTo(0.0, duration: Duration(milliseconds: 320), curve: Curves.easeOutCubic);

                      MessageMiddleware.listFriendFromSave(widget.user.email).then((List<Message> messages) {
                        _stream.add(messages);
                      });
                    },
                    sent: (view, message) {
                      MessageMiddleware.listFriendFromSave(widget.user.email).then((List<Message> messages) {
                        if(messages.indexWhere((m) => m.id == message.id) < 0) {
                          messages.add(message);
                          _stream.add(messages);
                        } else {
                          messages[messages.indexWhere((m) => m.id == message.id)].state = sent;
                          _stream.add(messages);
                        }
                      });
                    }
                ),
              ],
            )
        ),
      ),
    );
  }
  String statustostring(int state) {

    switch(state) {
      case pending:
        return 'request sent';
      case unapproved:
        return 'friend request';
      case accepted:
        return null;
      default:
        return null;
    }
  }
  String datetostring(DateTime init, DateTime fin) {
    switch(fin.day - init.day){
      case 0:
      case 1: return 'today';
      case 2: return 'yesterday';
      default: return init.day.toString() + '/' + init.month.toString();
    }
  }

  /*
  Here we are trying to establish a connection to firebase in order to refresh
  the user interface each time the user has a notification for a new message
   */
  Future<FirebaseMessaging> initfirebase(BuildContext context) async {
    return (new FirebaseMessaging())..configure(
      onMessage: (Map<String, dynamic> message) async {
        String instruction = message['data']['instruction'];
        if(instruction == 'message_delivery'){
          UserMiddleware.fromSave().then((User user){

            MessageController().paged(email: user.email, token: user.token, friend: jsonDecode(message['data']['sender'])['email'])
              .then((List<Message> messages) {
                MessageMiddleware.listFriendFromSave(widget.user.email).then((List<Message> messages) {
                  _stream.sink.add(messages);
                });
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
              MessageMiddleware.listFriendFromSave(widget.user.email).then((List<Message> messages) {
                _stream.sink.add(messages);
              });
            });
          });
        }
      },
    );
  }
}